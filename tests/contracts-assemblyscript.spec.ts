// Copyright 2019 Parity Technologies (UK) Ltd.
// This file is part of Substrate.

// Substrate is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Substrate is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Substrate. If not, see <http://www.gnu.org/licenses/>.

import { ApiPromise, SubmittableResult, WsProvider } from "@polkadot/api";
import testKeyring from "@polkadot/keyring/testing";
import { bnToHex, hexToBn, u8aToHex } from "@polkadot/util";
import { randomAsU8a } from "@polkadot/util-crypto";
import { KeyringPair } from "@polkadot/keyring/types";
import { Address, ContractInfo, Balance, Hash } from "@polkadot/types/interfaces";
import BN from "bn.js";

import { ALICE, BOB, CREATION_FEE, WSURL } from "./consts";
import {
  callContract,
  instantiate,
  getContractStorage,
  putCode
} from "./utils";

// This is a test account that is going to be created and funded each test.
const keyring = testKeyring({ type: "sr25519" });
const bobPair = keyring.getPair(BOB);
const randomSeed = randomAsU8a(32);
let contractCaller: KeyringPair;
let api: ApiPromise;

beforeAll((): void => {
  jest.setTimeout(30000);
});

beforeEach(
  async (done): Promise<() => void> => {
    api = await ApiPromise.create({ provider: new WsProvider(WSURL) });
    contractCaller = keyring.addFromSeed(randomSeed);

    return api.tx.balances
      .transfer(contractCaller.address, CREATION_FEE.muln(3))
      .signAndSend(bobPair, (result: SubmittableResult): void => {
        if (
          result.status.isFinalized &&
          result.findRecord("system", "ExtrinsicSuccess")
        ) {
          console.log("New test account has been created.");
          done();
        }
      });
  }
);

describe("AssemblyScript Smart Contracts", () => {
  test("Raw Flipper contract", async (done): Promise<void> => {
    // See https://github.com/paritytech/srml-contracts-waterfall/issues/6 for info about
    // how to get the STORAGE_KEY of an instantiated contract

    const STORAGE_KEY = (new Uint8Array(32)).fill(2);
    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(
      api,
      contractCaller,
      "../contracts/assemblyscript/flipper/build/flipper-pruned.wasm"
    );
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    // Call contract with Action: 0x00 = Action::Flip()
    const address: Address = await instantiate(
      api,
      contractCaller,
      codeHash,
      "0x00",
      CREATION_FEE
    );
    expect(address).toBeDefined();

    const initialValue: Uint8Array = await getContractStorage(
      api,
      address,
      STORAGE_KEY
    );
    expect(initialValue).toBeDefined();
    expect(initialValue.toString()).toEqual("0x00");

    await callContract(api, contractCaller, address, "0x00");

    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toEqual("0x01");

    await callContract(api, contractCaller, address, "0x00");

    const flipBack = await getContractStorage(api, address, STORAGE_KEY);
    expect(flipBack.toString()).toEqual("0x00");

    done();
  });

  test("Raw Incrementer contract", async (done): Promise<void> => {
    const STORAGE_KEY = (new Uint8Array(32)).fill(1);

    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(
      api,
      contractCaller,
      "../contracts/assemblyscript/incrementer/build/incrementer-pruned.wasm"
    );
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    // Call contract with Action: 0x00 = Action::Inc()
    const address: Address = await instantiate(
      api,
      contractCaller,
      codeHash,
      "0x00",
      CREATION_FEE
    );
    expect(address).toBeDefined();

    // Call contract with Action: 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
    await callContract(api, contractCaller, address, "0x002a000000");
    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    // const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toBe("0x2a000000");

    const currentValue =  await callContract(api, contractCaller, address, "0x01");
    console.log(currentValue)

    done();
  });

  test.only("Raw Erc20 contract", async (done): Promise<void> => {
    const TOTAL_SUPPLY_STORAGE_KEY = (new Uint8Array(32)).fill(3);
    // 1. Deploy & instantiate the contract 
    // 2. Test if the TOTAL_SUPPLY_STORAGE_KEY holds the CREATION_FEE as a value
    // 3. Test if the CALLER storage holds the totalSupply of tokens
    // 4. Call the transfer function to Transfer some tokens to a different account
    // 5. Get the BalanceOf the receiver account
    
    // 1. Instantiate the contract 
    //
    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(
      api,
      contractCaller,
      "../contracts/assemblyscript/erc20/build/erc20-pruned.wasm"
    );
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    const address: Address = await instantiate(
      api,
      contractCaller,
      codeHash,
      "0x00",
      CREATION_FEE
    );
    expect(address).toBeDefined();

    // 2. Test if the TOTAL_SUPPLY_STORAGE_KEY holds the CREATION_FEE as a value
    //
    // Get the totalSupply of the contract from storage
    const totalSupplyRaw = await getContractStorage(api, address, TOTAL_SUPPLY_STORAGE_KEY);
    // Convert unsigned 128 bit integer returned as a little endian hex value 
    // From Storage: 0x000014bbf08ac6020000000000000000
    // Converted to <BN: 2c68af0bb140000>
    const totalSupply = hexToBn(totalSupplyRaw.toString(), true);
    // Test if the totalSupply value in storage equals the CREATION_FEE
    expect(totalSupply.eq(CREATION_FEE)).toBeTruthy();

    // 3. Test if the CALLER storage holds the totalSupply of tokens
    //
    // We know that the creator should own the total supply of the contract
    // after initialization. The return value should be of type Balance.
    // We get the value from storage and convert the returned hex value
    // to an BN instance to be able to compare the values.
    const creatorBalanceRaw = await getContractStorage(api, address, contractCaller.publicKey);
    const creatorBalance = hexToBn(creatorBalanceRaw.toString(), true);
    expect(creatorBalance.toString()).toBe(CREATION_FEE.toString());
    // console.log(creatorBalance);
    // console.log(contractCaller.publicKey)

    /*****************************/
    const MY_DUMMY = (new Uint8Array(32)).fill(55);
    const MY_DUMMY_KEYRING = keyring.addFromSeed(MY_DUMMY);
    const STATIC = keyring.getPair(ALICE);

 

    const oldValueRaw = await getContractStorage(api, address, MY_DUMMY);
    const oldValue = hexToBn(oldValueRaw.toString(), true);
    //console.log(oldValueRaw)
    //console.log(MY_DUMMY, oldValue)
    
    // await callContract(api, contractCaller, address, '0x03' + u8aToHex(contractCaller.publicKey, -1, false) + u8aToHex(MY_DUMMY, -1, false)) + 6511;
    await callContract(api, contractCaller, address, '0x03' + u8aToHex(contractCaller.publicKey, -1, false) + u8aToHex(MY_DUMMY, -1, false) + '26600000000000000000000000000000');
    const newValueRaw = await getContractStorage(api, address, contractCaller.publicKey);
    const newValue = hexToBn(newValueRaw.toString(), true);
    // console.log(newValueRaw)
    console.log(contractCaller.publicKey, newValue)

    const newValueRaw2 = await getContractStorage(api, address, MY_DUMMY);
    const newValue2 = hexToBn(newValueRaw2.toString(), true);
    console.log(MY_DUMMY, newValue2)

    /*****************************/

    // 4. Call the transfer function to Transfer some tokens to a different account
    
    // const recipient = keyring.addFromSeed(randomAsU8a(32));
    // const transferValue: BN = new BN(CREATION_FEE.divn(150), 'le');

    // const contractAction = 
    // "0x03" // First byte Action:Transfer
    // + u8aToHex(MY_DUMMY, -1, false) // Recipient u256 account publicKey to hex without the '0x' prefix
    // + u8aToHex(transferValue.toArrayLike(Buffer, 'le', 16), -1, false); // u128 bit integer of type Balance to hex (little endian)

    // console.log(MY_DUMMY)
    // console.log(contractCaller.publicKey)

    // await callContract(api, contractCaller, address, contractAction);
    // const newValueCaller = await getContractStorage(api, address, contractCaller.publicKey);
    // const newValue = await getContractStorage(api, address, MY_DUMMY);
    
    // console.log(hexToBn(newValueCaller.toString(), true))
    // console.log(hexToBn(newValue.toString(), true))
    // // expect(newValue.toString()).toBe("");
    // // expect(newValueCaller.toString()).toBe("");
    

    done();
  });
});