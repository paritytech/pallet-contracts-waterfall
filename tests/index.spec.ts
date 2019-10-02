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

describe('Rust Smart Contracts', () => {
  test('Flip contract', async (done): Promise<void>  => {
    const flipperAbi = require('../ink/examples/lang/flipper/target/old_abi.json');
    const STORAGE_KEY = '0xeb72c87e65bed3596d6fef83aeb784615cdac1be1328adf1c7336acd6ba9ff77';
    const abi: Abi = new Abi(flipperAbi);

    // Deploy contract code on chain and retrieve the code hash
    const codeHash: Hash = await putCode(api, testAccount, '../ink/examples/lang/flipper/target/flipper-pruned.wasm');
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    const address: Address = await instantiate(api, testAccount, codeHash, abi.deploy(), CREATION_FEE);
    expect(address).toBeDefined();

    const initialValue: Uint8Array = await getContractStorage(api, address, STORAGE_KEY);
    expect(initialValue).toBeDefined();
    expect(initialValue.toString()).toEqual('0x00');

    await callContract(api, testAccount, address, abi.messages.flip());

    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toEqual('0x01');

    done();
  });


  test('Raw incrementer contract', async (done): Promise<void>  => {
    const STORAGE_KEY = '0xf40ceaf86e5776923332b8d8fd3bef849cadb19c6996bc272af1f648d9566a4c';
    // Deploy contract code on chain and retrieve the code hash
    const codeHash: Hash = await putCode(api, testAccount, '../contracts/rust/raw-incrementer/target/raw_incrementer-pruned.wasm');
    expect(codeHash).toBeDefined();

    // Instantiate a new contract instance and retrieve the contracts address
    const address: Address = await instantiate(api, testAccount, codeHash, '0x00', CREATION_FEE);
    expect(address).toBeDefined();

    // Call contract with Action: 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
    await callContract(api, testAccount, address, '0x002a000000');

    const newValue = await getContractStorage(api, address, STORAGE_KEY);
    expect(newValue.toString()).toBe('0x2a000000');

    done();
  });

  test('Restoration contract', async (done): Promise<void>  => {
    // This test does the following:
    // 1. instantiates a contract
    // 2. fills it with data
    // 3. makes the contract to be evicted
    // 4. creates a restoration contract
    // 5. performs calls that rebuild the state of the evicted contract
    // 6. restores the contract
    // 7. checks that the restored contract is equivalent to the evicted.

    const STORAGE_KEY = '0xf40ceaf86e5776923332b8d8fd3bef849cadb19c6996bc272af1f648d9566a4c';

    // Deploy contract code on chain and retrieve the code hash
    const codeHash: Hash = await putCode(api, testAccount, '../contracts/rust/raw-incrementer/target/raw_incrementer-pruned.wasm');
    expect(codeHash).toBeDefined();

    // 1. Instantiate a new contract instance and retrieve the contracts address
    const address: Address = await instantiate(api, testAccount, codeHash, '0x00', CREATION_FEE);
    expect(address).toBeDefined();

    // 2. Fill contract with initial data
    // Call contract with Action: 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
    await callContract(api, testAccount, address, '0x002a000000');
 
    const initialValue: Uint8Array = await getContractStorage(api, address, STORAGE_KEY);
    expect(initialValue).toBeDefined();
    expect(initialValue.toString()).toBe('0x2a000000');

    // 3. Evict the contract
    // 0x02 = Action::SelfEvict
    await callContract(api, testAccount, address, '0x02');

    // Do the call again, in order to make sure that the contract is evicted due to the state rent.
    // The actual call doesn't matter, but let's use this to not invent anything new.
    await callContract(api, testAccount, address, '0x02');

    // Verify that the contract is actually evicted.
    let contractInfo = await api.query.contracts.contractInfoOf(address);
    expect((contractInfo as Option<ContractInfo>).unwrap().isTombstone).toBe(true);

    // 4. Re-deploy contract code on chain and retrieve the code hash
    const restoredCodeHash: Hash = await putCode(api, testAccount, '../contracts/rust/restore-contract/target/restore_contract-pruned.wasm');
    expect(restoredCodeHash).toBeDefined();

    const restoredAddress: Address = await instantiate(api, testAccount, restoredCodeHash, '0x00', CREATION_FEE);
    expect(restoredAddress).toBeDefined();
    
    // 5. performs calls that rebuild the state of the evicted contract
    let encodedPutAction =
      '0x00' // idx:  0x00 = Action::Inc
      + '01010101010101010101010101010101010101010101010101010101010101010110' // storage key
      + '2a000000'; // // little endian 32-bit integer, decimal number `42` toHex() === `2a`
    await callContract(api, testAccount, restoredAddress, encodedPutAction);

    // 6. Restore evicted contract 
    const encodedRestoreAction = 
      '0x01' // idx: 0x01 = Action::Get
      + u8aToHex(address.toU8a(), 256, false) // address to hex string without prefix
      + u8aToHex(codeHash.toU8a(), 256, false) // codeHash to hex string without prefix
      + '80000000000000000000000000000000'; // little endian 128 bit integer, decimal number `128` toHex() === `80`
    await callContract(api, testAccount, restoredAddress, encodedRestoreAction);

    // 7. Check that the restored contract is equivalent to the evicted.
    const newCounterValue =  await getContractStorage(api, address, STORAGE_KEY);
    expect(newCounterValue.toString()).toBe('0x2a000000');

    done();
  });
});

// 

// describe('AssemblyScript Smart Contracts', () => {
//   test('Flip contract', async (done): Promise<void>  => {
//     // Deploy contract code on chain and retrieve the code hash
//     const codeHash = await putCode(api, testAccount, '../contracts-assemblyscript/optimized.wasm');
//     expect(codeHash).toBeDefined();
//     console.log(codeHash)

//     done();
//   });
// });