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

import { ApiPromise, WsProvider } from '@polkadot/api';
import { Abi } from '@polkadot/api-contract';
import testKeyring from '@polkadot/keyring/testing';
import { randomAsU8a } from '@polkadot/util-crypto';
import { ClassOf, Enum, H256, Option, Tuple, u256 } from '@polkadot/types';
import { Address } from '@polkadot/types/interfaces';
import fs from 'fs';
import path from 'path';
import BN from 'bn.js';

const ALICE = '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY';
const DOT = new BN('1000000000000000');
const CREATION_FEE = DOT.muln(200);

class Restore extends Tuple {
    constructor(value: any) {
      super({
        dest_addr: ClassOf('AccountId'),
        code_hash: H256,
        rent_allowance: ClassOf('Balance'),
      }, value);
    }
  }

  class Put extends Tuple {
    constructor(value: any) {
      super({
        key: u256,
        value: Option
      }, value);
    }
  }

  class Action extends Enum {
    constructor(value: any, index: number) {
      super({
        put: Put,
        restore: Restore
      }, value, index);
    }
  }

async function sendAndFinalize(signer: any, tx: any) {
    return new Promise(function(resolve, reject) {
        tx.signAndSend(signer, (result: any) => {
            if (result.status.isFinalized) {
                resolve(result);
            }
        });
    });
}

async function createTestOrigin(api: ApiPromise) {
    const keyring = testKeyring();
    const alicePair = keyring.getPair(ALICE);
    let testOrigin = keyring.addFromSeed(randomAsU8a(32));

    let value = DOT.muln(500);
    let tx = api.tx.balances.transfer(testOrigin.address, value);

    let _ = await sendAndFinalize(alicePair, tx);

    return testOrigin;
}

// TODO: Introduce a class, that has `api` and `testOrigin`.

/// Returns code hash.
async function putCodeViaFile(api: ApiPromise, signer: any, fileName: string, gasRequired=500000) {
    let wasmCode = fs.readFileSync(path.join(__dirname, fileName)).toString('hex');
    let tx = api.tx.contracts.putCode(gasRequired, `0x${wasmCode}`);
    let result = await sendAndFinalize(signer, tx);

    const record = result.findRecord('contracts', 'CodeStored');
    if (!record) {
        throw 'no code stored event';
    }

    // Return code hash.
    return record.event.data[0];
}

async function instantiate(api: ApiPromise, signer: any, codeHash: string, inputData: any, endowment: BN, gasRequired=50000) {
    let tx = api.tx.contracts.instantiate(endowment, gasRequired, codeHash, inputData);
    let result = await sendAndFinalize(signer, tx);

    const record = result.findRecord('contracts', 'Instantiated');
    if (!record) {
        throw 'no instantiated event';
    }

    // Return the address of instantiated contract.
    return record.event.data[1];
}

async function call(api: ApiPromise, signer: any, contractAddress: Address, inputData: any, gasRequired=50000, endowment=0) {
    let tx = api.tx.contracts.call(contractAddress, endowment, gasRequired, inputData);
    await sendAndFinalize(signer, tx);
}

async function getContractStorage(api: ApiPromise, contractAddress: Address, storageKey: string) {
    let contractInfo = await api.query.contracts.contractInfoOf(contractAddress);
    let trieId = contractInfo.unwrap().asAlive.trieId.toString('hex');
    console.log(trieId);
    return await api.rpc.state.getChildStorage(trieId, storageKey);
}

describe('simplest contract', () => {
    // This is a test account that is going to be created and funded each test.
    let testOrigin: any;
    let api: ApiPromise;

    beforeEach(async (done) => {
        jest.setTimeout(45000);

        const provider = new WsProvider('ws://127.0.0.1:9944');
        api = await ApiPromise.create({ provider });

        testOrigin = await createTestOrigin(api);
        done(); // TODO: Remove along with the `done` param?
    });

    test('flip', async (done) => {
        const FLIP_FLAG_STORAGE_KEY = '0xeb72c87e65bed3596d6fef83aeb784615cdac1be1328adf1c7336acd6ba9ff77';

        let flipperAbi = JSON.parse(
            fs.readFileSync('../ink/examples/lang/flipper/target/old_abi.json')
        );
        const abi: Abi = new Abi(flipperAbi);

        let codeHash = await putCodeViaFile(
            api,
            testOrigin,
            '../ink/examples/lang/flipper/target/flipper-pruned.wasm'
        );
        let address = await instantiate(api, testOrigin, codeHash, abi.deploy(), CREATION_FEE);

        // Ensure that the initial value is equals to the expected one.
        let flipFlagOld = await getContractStorage(
            api,
            address,
            FLIP_FLAG_STORAGE_KEY
        );
        console.log(flipFlagOld.unwrap());
        expect(flipFlagOld.unwrap().toString()).toBe("0x00");

        await call(api, testOrigin, address, abi.messages.flip());

        // Verify the new value for flip.
        let flipFlagNew = await getContractStorage(
            api,
            address,
            FLIP_FLAG_STORAGE_KEY
        );
        expect(flipFlagNew.unwrap().toString()).toBe("0x01");
        done(); // TODO: Remove along with the `done` param?
    });

    test('raw-incrementer', async (done) => {
        let codeHash = await putCodeViaFile(
            api,
            testOrigin,
            '../contracts-ink/raw-incrementer/target/raw_incrementer-pruned.wasm'
        );
        let address = await instantiate(api, testOrigin, codeHash, '0x00', CREATION_FEE);

        // 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
        let msg = '0x002a000000';

        await call(api, testOrigin, address, msg);

        // The key actually is 0x010101..01. However, it seems to be
        // hashed before putting into the storage.
        const KEY = '0xf40ceaf86e5776923332b8d8fd3bef849cadb19c6996bc272af1f648d9566a4c';
        let counter = await getContractStorage(
            api,
            address,
            KEY
        );
        expect(counter.unwrap().toString()).toBe("0x2a000000");
        done();
    });

    test('restoration', async (done) => {
        const COUNTER_KEY = '0xf40ceaf86e5776923332b8d8fd3bef849cadb19c6996bc272af1f648d9566a4c';

        // This test does the following:
        // 1. instantiates a contract
        // 2. fills it with data
        // 3. makes the contract to be evicted
        // 4. creates a restoration contract
        // 5. performs calls that rebuild the state of the evicted contract
        // 6. restores the contract
        // 7. checks that the restored contract is equivalent to the evicted.

        // 1. Instantiate a contract.
        let incrementerCodeHash = await putCodeViaFile(
            api,
            testOrigin,
            '../contracts-ink/raw-incrementer/target/raw_incrementer-pruned.wasm'
        );
        let address = await instantiate(
            api,
            testOrigin,
            incrementerCodeHash,
            '0x00',
            CREATION_FEE
        );
        console.log("address: ", address); // TODO: Remove
        console.log("incrementerCodeHash: ", incrementerCodeHash);

        // 2. Fill it with initial data.
        // 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
        await call(api, testOrigin, address, '0x002a000000');

        let counter = await getContractStorage(
            api,
            address,
            COUNTER_KEY
        );
        expect(counter.unwrap().toString()).toBe("0x2a000000");

        // 3. Evict the contract
        // 0x02 = Action::SelfEvict
        await call(api, testOrigin, address, '0x02');

        // Do the call again, in order to make sure that the contract is evicted due to the state
        // rent. The actual call doesn't matter, but let's use this to not invent anything new.
        await call(api, testOrigin, address, '0x02');

        // Verify that the contract is actually evicted.
        let contractInfo = await api.query.contracts.contractInfoOf(address);
        expect(contractInfo.unwrap().isTombstone).toBe(true);

        // 4. Create a restoration contract
        let restoreCodeHash = await putCodeViaFile(
            api,
            testOrigin,
            '../contracts-ink/restore-contract/target/restore_contract-pruned.wasm'
        );
        let restoreContractAddress = await instantiate(
            api,
            testOrigin,
            restoreCodeHash,
            '0x00',
            CREATION_FEE
        );

        // TODO: Validate that the contract doesn't accept calls from non-owner.

        // 5. Build [almost] identical state to the restored contract.
        // Action::Put {
        //   key: [0x01; 32],
        //   value: Some(42u32.encode()),
        // }
        let encodedPutAction =
            //  new Action(
            //      new Put(
            //          '0x010101010101010101010101010101010101010101010101010101010101010101',
            //          new Option(Bytes, '0x2a000000')
            //      ),
            //      0 // idx
            //  ).toHex();
            '0x00010101010101010101010101010101010101010101010101010101010101010101102a000000';
        await call(api, testOrigin, restoreContractAddress, encodedPutAction);

        // 6. Restore the contract
        // Action::Restore {
        //   dest_addr,
        //   code_hash,
        //   endowment: 128,
        // }
        let encodedRestoreAction =
            new Action(
                new Restore([address, incrementerCodeHash, 128]),
                1 // idx
            ).toHex();
        console.log(encodedRestoreAction);
        await call(api, testOrigin, restoreContractAddress, encodedRestoreAction);

        let counterNew = await getContractStorage(
            api,
            address,
            COUNTER_KEY
        );
        expect(counterNew.unwrap().toString()).toBe("0x2a000000");

        done();
    });
});