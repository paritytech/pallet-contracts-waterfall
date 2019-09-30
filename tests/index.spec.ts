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

import { ApiPromise, SubmittableResult, WsProvider } from '@polkadot/api';
import { Abi } from '@polkadot/api-contract';
import testKeyring from '@polkadot/keyring/testing';
import { randomAsU8a } from '@polkadot/util-crypto';
import { ClassOf, Enum, H256, Option, StorageData, Tuple, u256 } from '@polkadot/types';
import { Address, ContractInfo, Hash, EventRecord } from '@polkadot/types/interfaces';
import fs from 'fs';
import path from 'path';
import BN from 'bn.js';
import { KeyringPair } from '@polkadot/keyring/types';
import { StorageEntry } from '@polkadot/types/primitive/StorageKey';

const WSURL = 'ws://127.0.0.1:9944';
const ALICE = '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY';
const DOT: BN = new BN('1000000000000000');
const CREATION_FEE: BN = DOT.muln(200);

async function sendAndReturnResult(signer: KeyringPair, tx: any) {
  return new Promise(function(resolve) {
      tx.signAndSend(signer, (result: SubmittableResult) => {
          if (result.status.isFinalized) {
              resolve(result as SubmittableResult);
          }
      });
  });
}

async function putCode(api: ApiPromise, signer: KeyringPair, fileName: string, gasRequired: number = 500000) {
  const wasmCode = fs.readFileSync(path.join(__dirname, fileName)).toString('hex');
  const tx = api.tx.contracts.putCode(gasRequired, `0x${wasmCode}`);
  const result: any = await sendAndReturnResult(signer, tx);
  const record = result.findRecord('contracts', 'CodeStored');

  if (!record) {
      throw 'no code stored event';
  }
  // Return code hash.
  return record.event.data[0];
}

async function instantiate(api: ApiPromise, signer: KeyringPair, codeHash: string, inputData: any, endowment: BN, gasRequired: number = 50000) {
  const tx = api.tx.contracts.instantiate(endowment, gasRequired, codeHash, inputData);
  const result: any = await sendAndReturnResult(signer, tx);
  const record = result.findRecord('contracts', 'Instantiated');

  if (!record) {
      throw 'no instantiated event';
  }

  // Return the address of instantiated contract.
  return record.event.data[1];
}

async function getContractStorage(api: ApiPromise, contractAddress: Address, storageKey: string) {
  const contractInfo = await api.query.contracts.contractInfoOf(contractAddress);
  return await api.rpc.state.getChildStorage(
    (contractInfo as Option<ContractInfo>).unwrap().asAlive.trieId,
    storageKey
  );
}

describe('Basic contract examples', () => {
  // This is a test account that is going to be created and funded each test.
  let testAccount: KeyringPair;
  let api: ApiPromise;
  const keyring = testKeyring({ type: 'sr25519' });
  const alicePair = keyring.getPair(ALICE);

  beforeAll((): void => {
    jest.setTimeout(12000);
  });
  afterAll((): void => {
    jest.setTimeout(5000);
  });

  beforeEach(async (done): Promise<() => void> => {
    api = await ApiPromise.create({ provider: new WsProvider( WSURL) });
    testAccount = keyring.addFromSeed(randomAsU8a(32));

    return (
      api.tx.balances
        .transfer(testAccount.address, DOT.muln(500))
        .signAndSend(alicePair, (result: SubmittableResult): void => {
          if (result.status.isFinalized && result.findRecord('system', 'ExtrinsicSuccess')) {
            console.log('YAY DONE!!')
            done();
          }
        })
    )
  });

  describe('Rust Smart Contracts', () => {
    test('Flip contract', async (done): Promise<void>  => {
      const flipperAbi = require('../ink/examples/lang/flipper/target/old_abi.json');
      const FLIP_FLAG_STORAGE_KEY = '0xeb72c87e65bed3596d6fef83aeb784615cdac1be1328adf1c7336acd6ba9ff77';
      const abi: Abi = new Abi(flipperAbi);

      // Deploy contract code on chain and retrieve the code hash
      const codeHash = await putCode(api, testAccount, '../ink/examples/lang/flipper/target/flipper-pruned.wasm');
      expect(codeHash).toBeDefined();

      // Instantiate a new contract instance and retrieve the contracts address
      const address = await instantiate(api, testAccount, codeHash, abi.deploy(), CREATION_FEE);
      expect(address).toBeDefined();

      const initialValue = await getContractStorage(api, address, FLIP_FLAG_STORAGE_KEY);
      expect(initialValue).toBeDefined();
      // expect(initialValue).toEqual('0x00');

      console.log(codeHash, address, initialValue)

      done();
    });

  });

  describe('AssemblyScript Smart Contracts', () => {
    test('Flip contract', async (done): Promise<void>  => {
      // Deploy contract code on chain and retrieve the code hash
      const codeHash = await putCode(api, testAccount, '../contracts-assemblyscript/optimized.wasm');
      expect(codeHash).toBeDefined();
      console.log(codeHash)

      done();
    });
  });
});