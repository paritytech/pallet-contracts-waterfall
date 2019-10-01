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
import { KeyringPair } from '@polkadot/keyring/types';
import { Address, Hash } from '@polkadot/types/interfaces';
import BN from 'bn.js';

import { ALICE, CREATION_FEE, GAS_REQUIRED, WSURL } from './consts';
import { instantiate, getContractStorage, putCode, sendAndReturnFinalized } from './utils';

// This is a test account that is going to be created and funded each test.
const keyring = testKeyring({ type: 'sr25519' });
const alicePair = keyring.getPair(ALICE);
let testAccount: KeyringPair;
let api: ApiPromise;

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
      .transfer(testAccount.address, CREATION_FEE.muln(3))
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
    const codeHash: Hash = await putCode(api, testAccount, '../ink/examples/lang/flipper/target/flipper-pruned.wasm');
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    const address: Address = await instantiate(api, testAccount, codeHash, abi.deploy(), CREATION_FEE);
    expect(address).toBeDefined();

    const initialValue: Uint8Array = await getContractStorage(api, address, FLIP_FLAG_STORAGE_KEY);
    expect(initialValue).toBeDefined();
    expect(initialValue.toString()).toEqual('0x00');

    const tx = api.tx.contracts.call(address, 0, GAS_REQUIRED, abi.messages.flip());
    await sendAndReturnFinalized(testAccount, tx);

    const newValue = await getContractStorage(api, address, FLIP_FLAG_STORAGE_KEY);
    expect(newValue.toString()).toEqual('0x01');

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