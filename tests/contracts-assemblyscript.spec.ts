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
import { u8aToHex } from '@polkadot/util';
import { randomAsU8a } from '@polkadot/util-crypto';
import { KeyringPair } from '@polkadot/keyring/types';
import { Option } from '@polkadot/types';
import { Address, ContractInfo, Hash } from '@polkadot/types/interfaces';

import { ALICE, CREATION_FEE, WSURL } from './consts';
import { callContract, instantiate, getContractStorage, putCode } from './utils';

// This is a test account that is going to be created and funded each test.
const keyring = testKeyring({ type: 'sr25519' });
const alicePair = keyring.getPair(ALICE);
let testAccount: KeyringPair;
let api: ApiPromise;

beforeAll((): void => {
  jest.setTimeout(30000);
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
          console.log('New test account has been created.')
          done();
        }
      })
  )
});

describe('AssemblyScript Smart Contracts', () => {
  const STORAGE_KEY = '0xf40ceaf86e5776923332b8d8fd3bef849cadb19c6996bc272af1f648d9566a4c';
  test('Flip contract', async (done): Promise<void>  => {
    // Deploy contract code on chain and retrieve the code hash
    const codeHash = await putCode(api, testAccount, '../contracts/assemblyscript/incrementer/build/incrementer-pruned.wasm');
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    // Call contract with Action: 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
    const address: Address = await instantiate(api, testAccount, codeHash, '0x00', CREATION_FEE);
    expect(address).toBeDefined();

    // Call contract with Action: 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
    await callContract(api, testAccount, address, '0x002a000000');

    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toBe('0x2a000000');

    done();
  });
});