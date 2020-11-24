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
import { Abi } from '@polkadot/api-contract';
import BN from "bn.js";

import { CHARLIE as CHARLIE_ADDRESS, DOT, CREATION_FEE, WSURL } from "./consts";
import {
  callContract,
  instantiate,
  getContractStorage,
  putCode,
  rpcContract,
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
  test("Raw Flipper contract", async (done): Promise<void> => {
    // The next two lines are a not so pretty workaround until the new metadata format has been fully implemented
    const metadata = require("../contracts/solidity/flipper/flipper.json");
    const abi = new Abi(metadata, api.registry.getChainProperties());

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
      abi.constructors[0](1),
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

    await callContract(api, contractCreator, address, abi.findMessage('flip').toU8a([]));

    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toEqual("0x00");

    let res = await rpcContract(api, address, abi.findMessage('get').toU8a([]));
    expect(res.toString()).toEqual("0x00");

    await callContract(api, contractCreator, address, abi.findMessage('flip').toU8a([]));

    const flipBack = await getContractStorage(api, address, STORAGE_KEY);
    expect(flipBack.toString()).toEqual("0x01");

    res = await rpcContract(api, address, abi.findMessage('get').toU8a([]));
    expect(res.toString()).toEqual("0x01");

    done();
  });

  test("Raw Creator contract", async (done): Promise<void> => {
    const metadata = require("../contracts/solidity/creator/creator.json");
    const abi = new Abi(metadata, api.registry.getChainProperties());

    // Deploy contract code on chain and retrieve the code hash
    const otherCodeHash = await putCode(
      api,
      contractCreator,
      "../contracts/solidity/creator/other.wasm"
    );

    expect(otherCodeHash).toBeDefined();

    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(
      api,
      contractCreator,
      "../contracts/solidity/creator/creator.wasm"
    );

    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    const address: Address = await instantiate(
      api,
      contractCreator,
      codeHash,
      abi.constructors[0].toU8a([]),
      CREATION_FEE
    );

    expect(address).toBeDefined();

    // what is the balance
    let res = await rpcContract(api, address, abi.findMessage('balance').toU8a([]));
    let balance = new BN(res, 16, 'le');
    // the balance should be less than the creation free
    expect(balance.cmp(CREATION_FEE)).toBeLessThan(0);
    // the balance should be 99% or more than the creation
    expect(balance.cmp(CREATION_FEE.muln(99).divn(100))).toBeGreaterThan(0);

    await callContract(api, contractCreator, address, abi.findMessage('createChild').toU8a([DOT.muln(10)]));

    // what is the child balance
    res = await rpcContract(api, address, abi.findMessage('childBalance').toU8a([]));
    balance = new BN(res, 16, 'le');

    expect(balance.cmpn(10000000)).toBeGreaterThan(0);
    expect(balance.cmp(DOT.muln(10))).toBeLessThan(0);

    // do a call and send value along with it
    await callContract(api, contractCreator, address, abi.findMessage('childSetVal').toU8a([1024, DOT.muln(10)]));

    res = await rpcContract(api, address, abi.findMessage('childGetVal').toU8a([]));

    expect((new BN(res, 16, 'le')).toNumber()).toEqual(1024);

    // what is the child balance
    res = await rpcContract(api, address, abi.findMessage('flip').toU8a([]));
    let new_balance = new BN(res, 16, 'le');

    expect(new_balance.cmp(balance)).toBeGreaterThan(0);

    done();
  });
});