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
import { hexToBn, u8aToHex } from "@polkadot/util";
import { randomAsU8a } from "@polkadot/util-crypto";
import { KeyringPair } from "@polkadot/keyring/types";
import { Address, ContractInfo, Hash, StorageData } from "@polkadot/types/interfaces";
import BN from "bn.js";
import sha256 from "fast-sha256";
 
 
import { ALICE as ALICE_ADDRESS, BOB as BOB_ADDRESS, CREATION_FEE, WSURL } from "./consts";
import {
  callContract,
  instantiate,
  getContractStorage,
  putCode
} from "./utils";

// This is a test account that is going to be created and funded before each test.
const keyring = testKeyring({ type: "sr25519" });
const ALICE = keyring.getPair(ALICE_ADDRESS);
const BOB = keyring.getPair(BOB_ADDRESS);
const randomSeed = randomAsU8a(32);
let contractCreator: KeyringPair;
let api: ApiPromise;

beforeAll((): void => {
  jest.setTimeout(40000);
});

beforeEach(
  async (done): Promise<() => void> => {
    api = await ApiPromise.create({ provider: new WsProvider(WSURL) });
    contractCreator = keyring.addFromSeed(randomSeed);

    return api.tx.balances
      .transfer(contractCreator.address, CREATION_FEE.muln(5))
      .signAndSend(BOB, (result: SubmittableResult): void => {
        if (
          result.status.isInBlock &&
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
    // See https://github.com/paritytech/pallet-contracts-waterfall/issues/6 for info about
    // how to get the STORAGE_KEY of an instantiated contract

    const STORAGE_KEY = (new Uint8Array(32)).fill(2);
    // Deploy contract code on chain and retrieve the code hash
    const codeHash: Hash = await putCode(
      api,
      contractCreator,
      "../contracts/assemblyscript/flipper/build/flipper-pruned.wasm"
    );
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    // Call contract with Action: 0x00 = Action::Flip()
    const address: Address = await instantiate(
      api,
      contractCreator,
      codeHash,
      "0x00",
      CREATION_FEE
    );
    expect(address).toBeDefined();

    const initialValue: StorageData = await getContractStorage(
      api,
      address,
      STORAGE_KEY
    );
    expect(initialValue).toBeDefined();
    expect(initialValue.toString()).toEqual("0x00");

    await callContract(api, contractCreator, address, "0x00");

    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toEqual("0x01");

    await callContract(api, contractCreator, address, "0x00");

    const flipBack = await getContractStorage(api, address, STORAGE_KEY);
    expect(flipBack.toString()).toEqual("0x00");

    done();
  });

  test("Raw Incrementer contract", async (done): Promise<void> => {
    const STORAGE_KEY = (new Uint8Array(32)).fill(1);

    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(
      api,
      contractCreator,
      "../contracts/assemblyscript/incrementer/build/incrementer-pruned.wasm"
    );
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    // Call contract with Action: 0x00 = Action::Inc()
    const address: Address = await instantiate(
      api,
      contractCreator,
      codeHash,
      "0x00",
      CREATION_FEE
    );
    expect(address).toBeDefined();

    // Call contract with Action: 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
    await callContract(api, contractCreator, address, "0x002a000000");

    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    // const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toBe("0x2a000000");
    done();
  });

  test("Raw Erc20 contract", async (done): Promise<void> => {
    /**
    * 1. Deploy & instantiate the contract
    * 2. Test if the TOTAL_SUPPLY_STORAGE_KEY holds the CREATION_FEE as a value
    * 3. Test if FRANKIES storage holds the totalSupply of tokens
    * 4. Use the transfer function to transfer some tokens from the FRANKIES account to a new address CAROL
    * 5. Approve withdrawal amount from FRANKIES account for new 'spender' account DAN
    * 6. Use the transferFrom function to transfer some ERC20 tokens from FRANKIES to a new account OSCAR
    * 7. Use the transferFrom to let DAN try to transfer the full original allowance from FRANKIE to OSCAR. This attempt should fail.
    **/

    const TOTAL_SUPPLY_STORAGE_KEY = (new Uint8Array(32)).fill(3);

    // FRANKIE is our contract creator account
    const FRANKIE = contractCreator;
    // FRANKIE will transfer 2000000000000000 tokens to CAROL
    const CAROL = keyring.addFromSeed(randomAsU8a(32));
    // FRANKIE will approve, that DAN is allowed to transfer 5000000000000000 of her tokens on her behalf
    const DAN = keyring.addFromSeed(randomAsU8a(32));
    // DAN will then transfer 10000000 of the 5000000000000000 approved tokens from FRANKIE to OSCAR
    const OSCAR = keyring.addFromSeed(randomAsU8a(32));

    await api.tx.balances
      .transfer(DAN.address, CREATION_FEE.muln(5))
      .signAndSend(ALICE, (result: SubmittableResult): void => {
        if (result.status.isInBlock && result.findRecord("system", "ExtrinsicSuccess")) {
          console.log("DANs account is now funded.");
        }
      });

    /**
    * 1. Deploy & instantiate the contract
    **/

    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(
      api,
      FRANKIE,
      "../contracts/assemblyscript/erc20/build/erc20-pruned.wasm"
    );
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    const address: Address = await instantiate(
      api,
      FRANKIE,
      codeHash,
      "0x00",
      CREATION_FEE
    );
    expect(address).toBeDefined();

    /**
    * 2. Test if the TOTAL_SUPPLY_STORAGE_KEY holds the CREATION_FEE as a value
    **/

    // Get the totalSupply of the contract from storage
    const totalSupplyRaw = await getContractStorage(api, address, TOTAL_SUPPLY_STORAGE_KEY);
    // Convert unsigned 128 bit integer returned as a little endian hex value 
    // From Storage: 0x000014bbf08ac6020000000000000000
    // Converted to <BN: 2c68af0bb140000>
    const totalSupply = hexToBn(totalSupplyRaw.toString(), true);
    // Test if the totalSupply value in storage equals the CREATION_FEE
    expect(totalSupply.eq(CREATION_FEE)).toBeTruthy();

    /**
    *  3. Test if FRANKIES storage holds the totalSupply of tokens
    *
    * We know that the creator should own the total supply of the contract
    * after initialization. The return value should be of type Balance.
    * We get the value from storage and convert the returned hex value
    * to an BN instance to be able to compare the values.
    **/

    let frankieBalanceRaw = await getContractStorage(api, address, FRANKIE.publicKey);
    let frankieBalance = hexToBn(frankieBalanceRaw.toString(), true);
    expect(frankieBalance.toString()).toBe(CREATION_FEE.toString());

    /**
    * 4. Use the transfer function to transfer some tokens from the FRANKIES account to CAROLS account
    **/

    const paramsTransfer = 
    '0x02' // 1 byte: First byte Action.Transfer
    + u8aToHex(CAROL.publicKey, -1, false) // 32 bytes: Hex encoded new account address as u256
    + '00008D49FD1A07000000000000000000'; // 16 bytes: Amount of tokens to transfer as u128 little endian hex (2000000000000000 in decimal)) value

    await callContract(api, FRANKIE, address, paramsTransfer);

    frankieBalanceRaw = await getContractStorage(api, address, FRANKIE.publicKey);
    frankieBalance = hexToBn(frankieBalanceRaw.toString(), true);
    const carolBalanceRaw = await getContractStorage(api, address, CAROL.publicKey);
    const carolBalance = hexToBn(carolBalanceRaw.toString(), true);
    let frankieBalanceNew = totalSupply.sub(new BN(2000000000000000));
    expect(frankieBalance.toString()).toBe(frankieBalanceNew.toString());
    expect(carolBalance.toString()).toBe("2000000000000000");
    frankieBalance = frankieBalanceNew;

    /**
    * 5. FRANKIE approves withdrawal amount for new account DAN
    **/

    // 16 bytes: Amount of tokens to transfer as u128 little endian hex (5000000000000000 in decimal)) value
    const approvedAmount = '0080e03779c311000000000000000000';
    const paramsApprove = 
    '0x04' // 1 byte: First byte Action.Transfer
    + u8aToHex(DAN.publicKey, -1, false) // 32 bytes: Hex encoded new spender account address as u256
    + approvedAmount;

    await callContract(api, FRANKIE, address, paramsApprove);

    // Create a new storage key from the FRANKIE.publicKey and the DAN.publicKey
    // It will be hashed to 32 byte hash with blake2b in the `getContractStorage` function before querying.
    const storageKeyApprove = new Uint8Array(64);
    storageKeyApprove.set(FRANKIE.publicKey);
    storageKeyApprove.set(DAN.publicKey, 32);

    let storageKeyApprove32: Uint8Array = sha256(storageKeyApprove) // default export is hash
    let allowanceRaw = await getContractStorage(api, address, storageKeyApprove32);

    expect(allowanceRaw.toString()).toBe('0x' + approvedAmount);


    /**
    *  6. Use the transferFrom function to let DAN transfer 10000000 ERC20 tokens from FRANKIE to OSCAR
    **/

    let oscarBalanceRaw = await getContractStorage(api, address, OSCAR.publicKey);
    let oscarBalance = hexToBn(oscarBalanceRaw.toString(), true);
    expect(oscarBalance.toString()).toBe("0");

    const paramsTransferFrom = 
      '0x03' // 1 byte: First byte Action.TransferFrom
      + u8aToHex(FRANKIE.publicKey, -1, false) // 32 bytes: Hex encoded contract caller address as u256
      + u8aToHex(OSCAR.publicKey, -1, false) // 32 bytes: Hex encoded new account address as u256
      + '80969800000000000000000000000000'; // 16 bytes: Amount of tokens to transfer as u128 little endian hex (10000000 in decimal)) value

    await callContract(api, DAN, address, paramsTransferFrom);

    frankieBalanceNew = frankieBalance.sub(new BN(10000000));

    frankieBalanceRaw = await getContractStorage(api, address, FRANKIE.publicKey);
    frankieBalance = hexToBn(frankieBalanceRaw.toString(), true);
    oscarBalanceRaw = await getContractStorage(api, address, OSCAR.publicKey);
    oscarBalance = hexToBn(oscarBalanceRaw.toString(), true);

    // Test that value has been deducted from the approved amount
    const allowanceUpdated = hexToBn(allowanceRaw.toString(), true).sub(new BN(10000000));
    allowanceRaw = await getContractStorage(api, address, storageKeyApprove32);
    let allowance = hexToBn(allowanceRaw.toString(), true);
    expect(allowance.toString()).toBe(allowanceUpdated.toString());

    expect(oscarBalance.toString()).toBe("10000000");
    expect(frankieBalance.toString()).toBe(frankieBalanceNew.toString());

    /**
    *  7. Use the transferFrom function to let DAN try to transfer the full original allowance from FRANKIE to OSCAR. This attempt should fail now, because that value would be higher than the remaining allowance from FRANKIE to DAN.
    **/

   const paramsTransferFromFail = 
     '0x03' // 1 byte: First byte Action.TransferFrom
     + u8aToHex(FRANKIE.publicKey, -1, false) // 32 bytes: Hex encoded contract caller address as u256
     + u8aToHex(OSCAR.publicKey, -1, false) // 32 bytes: Hex encoded new account address as u256
     + approvedAmount; // 16 bytes: Amount of tokens to transfer as u128 little endian hex value

   await callContract(api, DAN, address, paramsTransferFromFail);

   frankieBalanceRaw = await getContractStorage(api, address, FRANKIE.publicKey);
   frankieBalance = hexToBn(frankieBalanceRaw.toString(), true);
   oscarBalanceRaw = await getContractStorage(api, address, OSCAR.publicKey);
   oscarBalance = hexToBn(oscarBalanceRaw.toString(), true);

   // The balances of FRANKIE and OSCAR are remaining the same 
   expect(oscarBalance.toString()).toBe("10000000");
   expect(frankieBalance.toString()).toBe(frankieBalanceNew.toString());

   // Test that the allowance hasn't changed
   const allowanceOld = allowance;
   allowanceRaw = await getContractStorage(api, address, storageKeyApprove32);
   allowance = hexToBn(allowanceRaw.toString(), true);
   expect(allowanceOld.toString()).toBe(allowance.toString());

    done();
  });
});
