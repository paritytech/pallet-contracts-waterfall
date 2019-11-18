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
import { Abi } from "@polkadot/api-contract";
import testKeyring from "@polkadot/keyring/testing";
import { hexStripPrefix, hexToBn, u8aToHex } from "@polkadot/util";
import { randomAsU8a } from "@polkadot/util-crypto";
import { KeyringPair } from "@polkadot/keyring/types";
import { Option } from "@polkadot/types";
import { Address, ContractInfo, Balance, Hash } from "@polkadot/types/interfaces";
import BN from "bn.js";

import { BOB, CREATION_FEE, WSURL } from "./consts";
import {
  callContract,
  instantiate,
  getContractStorage,
  putCode
} from "./utils";

// This is a test account that is going to be created and funded each test.
const keyring = testKeyring({ type: "sr25519" });
const alicePair = keyring.getPair(BOB);
let testAccount: KeyringPair;
let api: ApiPromise;

beforeAll((): void => {
  jest.setTimeout(30000);
});

beforeEach(
  async (done): Promise<() => void> => {
    api = await ApiPromise.create({ provider: new WsProvider(WSURL) });
    testAccount = keyring.addFromSeed(randomAsU8a(32));

    return api.tx.balances
      .transfer(testAccount.address, CREATION_FEE.muln(3))
      .signAndSend(alicePair, (result: SubmittableResult): void => {
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
  test.skip("Raw Flipper contract", async (done): Promise<void> => {
    // See https://github.com/paritytech/srml-contracts-waterfall/issues/6 for info about
    // how to get the STORAGE_KEY of an instantiated contract

    const STORAGE_KEY = "0xd9818087de7244abc1b5fcf28e55e42c7ff9c678c0605181f37ac5d7414a7b95";
    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(
      api,
      testAccount,
      "../contracts/assemblyscript/flipper/build/flipper-pruned.wasm"
    );
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    // Call contract with Action: 0x00 = Action::Flip()
    const address: Address = await instantiate(
      api,
      testAccount,
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

    await callContract(api, testAccount, address, "0x00");

    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toEqual("0x01");

    await callContract(api, testAccount, address, "0x00");

    const flipBack = await getContractStorage(api, address, STORAGE_KEY);
    expect(flipBack.toString()).toEqual("0x00");

    done();
  });

  test.skip("Raw Incrementer contract", async (done): Promise<void> => {
    const STORAGE_KEY = "0xf40ceaf86e5776923332b8d8fd3bef849cadb19c6996bc272af1f648d9566a4c";
    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(
      api,
      testAccount,
      "../contracts/assemblyscript/incrementer/build/incrementer-pruned.wasm"
    );
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    // Call contract with Action: 0x00 = Action::Inc()
    const address: Address = await instantiate(
      api,
      testAccount,
      codeHash,
      "0x00",
      CREATION_FEE
    );
    expect(address).toBeDefined();

    // Call contract with Action: 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
    await callContract(api, testAccount, address, "0x002a000000");

    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toBe("0x2a000000");

    done();
  });

  test("Raw Erc20 contract", async (done): Promise<void> => {
    const TOTAL_SUPPLY_STORAGE_KEY = "0xfc14ac676780c40e5cfeb5b8701b14761a89b5519eaf663b29e7f8abbdc72195";
    const CREATOR_STORAGE_KEY = "0x89eb0d6a8a691dae2cd15ed0369931ce0a949ecafa5c3f93f8121833646e15c3";

    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(
      api,
      testAccount,
      "../contracts/assemblyscript/erc20/build/erc20-pruned.wasm"
    );
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    // Call contract with Action: 0x00 = Action::Inc()
    const address: Address = await instantiate(
      api,
      testAccount,
      codeHash,
      "0x00",
      CREATION_FEE
    );
    expect(address).toBeDefined();

    const totalSupplyRaw = await getContractStorage(api, address, TOTAL_SUPPLY_STORAGE_KEY);
    // Convert 128 bit little endian hex value 
    const totalSupply = hexToBn(totalSupplyRaw.toString(), true);
    expect(totalSupply.eq(CREATION_FEE)).toBeTruthy();

    // We know that the return value should be of type Balance.
    // So we convert the hex value returned from Storage as little endian value 
    // to an BN instance to be able to compare the values.
    const creatorBalanceRaw = await getContractStorage(api, address, CREATOR_STORAGE_KEY);
    const creatorBalance = hexToBn(creatorBalanceRaw.toString(), true);
    expect(creatorBalance.eq(totalSupply)).toBeTruthy();


    // // Call contract with Action: 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
    // await callContract(api, testAccount, address, "0x002a000000");

    // const newValue = await getContractStorage(api, address, STORAGE_KEY);
    // expect(newValue.toString()).toBe("0x2a000000");

    done();
  });
});
