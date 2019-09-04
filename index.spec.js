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

const { ApiPromise, WsProvider } = require('@polkadot/api');
const { Abi } = require('@polkadot/api-contract');
const testKeyring = require('@polkadot/keyring/testing');
const { randomAsU8a } = require('@polkadot/util-crypto');
const { Option, Vec, u8, Bytes, Tuple, Enum, AccountId, U256, H256, U128, ClassOf } = require('@polkadot/types');
const BN = require('bn.js');
const fs = require('fs');

const ALICE = '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY';
const DOT = new BN('1000000000000000');

class Restore extends Tuple {
    constructor(value) {
      super({
        dest_addr: ClassOf('AccountId'),
        code_hash: H256,
        rent_allowance: ClassOf('Balance'),
      }, value);
    }
  }

  class Put extends Tuple {
    constructor(value) {
      super({
        key: U256,
        value: Option.with(Bytes)
      }, value);
    }
  }

  class Action extends Enum {
    constructor(value, index) {
      super({
        put: Put,
        restore: Restore
      }, value, index);
    }
  }

async function sendAndFinalize(signer, tx) {
    return new Promise(function(resolve, reject) {
        tx.signAndSend(signer, (result) => {
            if (result.status.isFinalized) {
                resolve(result);
            }
        });
    });
}

async function createTestOrigin(api) {
    const keyring = testKeyring.default();
    const alicePair = keyring.getPair(ALICE);
    let testOrigin = keyring.addFromSeed(randomAsU8a(32));

    let value = DOT.muln(500);
    let tx = api.tx.balances.transfer(testOrigin.address, value);

    let _ = await sendAndFinalize(alicePair, tx);

    return testOrigin;
}

// TODO: Introduce a class, that has `api` and `testOrigin`.

/// Returns code hash.
async function putCodeViaFile(api, signer, fileName, gasRequired=500000) {
    let wasmCode = fs.readFileSync(fileName).toString('hex');
    let tx = api.tx.contracts.putCode(gasRequired, `0x${wasmCode}`);
    let result = await sendAndFinalize(signer, tx);

    const record = result.findRecord('contracts', 'CodeStored');
    if (!record) {
        throw 'no code stored event';
    }

    // Return code hash.
    return record.event.data[0];
}

async function instantiate(api, signer, codeHash, inputData, endowment, gasRequired=50000) {
    let tx = api.tx.contracts.create(endowment, gasRequired, codeHash, inputData);
    let result = await sendAndFinalize(signer, tx);

    const record = result.findRecord('contracts', 'Instantiated');
    if (!record) {
        throw 'no instantiated event';
    }

    // Return the address of instantiated contract.
    return record.event.data[1];
}

async function call(api, signer, contractAddress, inputData, gasRequired=50000, endowment=0) {
    let tx = api.tx.contracts.call(contractAddress, endowment, gasRequired, inputData);
    await sendAndFinalize(signer, tx);
}

async function getContractStorage(api, contractAddress, storageKey) {
    let contractInfo = await api.query.contracts.contractInfoOf(contractAddress);
    let trieId = contractInfo.unwrap().asAlive.trieId.toString('hex');
    console.log(trieId);
    return await api.rpc.state.getChildStorage(trieId, storageKey);
}

describe('simplest contract', () => {
    // This is a test account that is going to be created and funded each test.
    let testOrigin;
    let api;

    beforeEach(async (done) => {
        jest.setTimeout(45000);

        const provider = new WsProvider('ws://127.0.0.1:9944');
        api = await ApiPromise.create({ provider });

        testOrigin = await createTestOrigin(api);
        done(); // TODO: Remove along with the `done` param?
    });

    test('flip', async (done) => {
        const CREATION_FEE = DOT.muln(200);
        const FLIP_FLAG_STORAGE_KEY = '0xeb72c87e65bed3596d6fef83aeb784615cdac1be1328adf1c7336acd6ba9ff77';

        let flipperAbi = JSON.parse(
            fs.readFileSync('ink/examples/lang/flipper/target/old_abi.json')
        );
        abi = new Abi(flipperAbi);

        let codeHash = await putCodeViaFile(
            api,
            testOrigin,
            'ink/examples/lang/flipper/target/flipper-pruned.wasm'
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
        const CREATION_FEE = DOT.muln(200);
        let codeHash = await putCodeViaFile(
            api,
            testOrigin,
            'contracts/raw-incrementer/target/raw_incrementer-pruned.wasm'
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

        //
        // Instantiate a contract.
        //
        const CREATION_FEE = DOT.muln(200);
        let incrementerCodeHash = await putCodeViaFile(
            api,
            testOrigin,
            'contracts/raw-incrementer/target/raw_incrementer-pruned.wasm'
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

        //
        // Fill it with initial data.
        //

        // 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
        await call(api, testOrigin, address, '0x002a000000');

        let counter = await getContractStorage(
            api,
            address,
            COUNTER_KEY
        );
        expect(counter.unwrap().toString()).toBe("0x2a000000");

        //
        // Evict the contract
        //

        // 0x02 = Action::SelfEvict
        await call(api, testOrigin, address, '0x02');

        // Do the call again, in order to make sure that the contract is evicted due to the state
        // rent. The actual call doesn't matter, but let's use this to not invent anything new.
        await call(api, testOrigin, address, '0x02');

        // Verify that the contract is actually evicted.
        let contractInfo = await api.query.contracts.contractInfoOf(address);
        expect(contractInfo.unwrap().isTombstone).toBe(true);

        //
        // Create a restoration contract
        //

        let restoreCodeHash = await putCodeViaFile(
            api,
            testOrigin,
            'contracts/restore-contract/target/restore_contract-pruned.wasm'
        );
        let restoreContractAddress = await instantiate(
            api,
            testOrigin,
            restoreCodeHash,
            '0x00',
            CREATION_FEE
        );

        // TODO: Validate that the contract doesn't accept calls from non-owner.

        //
        // Build [almost] identical state to the restored contract.
        //

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

        //
        // Restore the contract
        //

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
