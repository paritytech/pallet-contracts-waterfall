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
import { randomAsU8a } from "@polkadot/util-crypto";
import { KeyringPair } from "@polkadot/keyring/types";
import { Address } from "@polkadot/types/interfaces";
 
import { CHARLIE as CHARLIE_ADDRESS, CREATION_FEE, WSURL } from "./consts";
import {
  callContract,
  instantiate,
  getContractStorage,
  putCode
} from "./utils";

// This is a test account that is going to be created and funded before each test.
const keyring = testKeyring({ type: "sr25519" });
const CHARLIE = keyring.getPair(CHARLIE_ADDRESS);
const randomSeed = randomAsU8a(32);
let contractCreator: KeyringPair;
let api: ApiPromise;

beforeAll((): void => {
  jest.setTimeout(30000);
});

beforeEach(
  async (done): Promise<() => void> => {
    api = await ApiPromise.create({ provider: new WsProvider(WSURL) });
    contractCreator = keyring.addFromSeed(randomSeed);

    return api.tx.balances
      .transfer(contractCreator.address, CREATION_FEE.muln(5))
      .signAndSend(CHARLIE, (result: SubmittableResult): void => {
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

describe("Solang Smart Contracts", () => {
  // skipped until test is fixed here: https://github.com/paritytech/pallet-contracts-waterfall/pull/66
  test("Raw Flipper contract", async (done): Promise<void> => {
    // See https://github.com/paritytech/pallet-contracts-waterfall/issues/6 for info about
    // how to get the STORAGE_KEY of an instantiated contract

    const STORAGE_KEY = (new Uint8Array(32)).fill(0);
    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(
      api,
      contractCreator,
      "../contracts/solidity/flipper/flipper.wasm"
    );
   
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    const address: Address = await instantiate(
      api,
      contractCreator,
      codeHash,
      "0xF81E7E1A01", // contract.constructors[0].selector 0xF81E7E1A + default value bool 0x01
      CREATION_FEE
    );

    expect(address).toBeDefined();

    const initialValue: Uint8Array = await getContractStorage(
      api,
      address,
      STORAGE_KEY
    );
    expect(initialValue).toBeDefined();
    expect(initialValue.toString()).toEqual("0x01");
    
    // Call contract with Action: 0xCDE4EFA9 = Action::Flip()
    await callContract(api, contractCreator, address, "0xCDE4EFA9");

    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toEqual("0x00");

    await callContract(api, contractCreator, address, "0xCDE4EFA9");

    const flipBack = await getContractStorage(api, address, STORAGE_KEY);
    expect(flipBack.toString()).toEqual("0x01");

    done();
  });
});
