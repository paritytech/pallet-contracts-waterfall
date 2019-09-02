const { ApiPromise, WsProvider, Bytes } = require('@polkadot/api');
const { Abi } = require('@polkadot/api-contract');
const testKeyring = require('@polkadot/keyring/testing');
const { randomAsU8a } = require('@polkadot/util-crypto');
const BN = require('bn.js');
const fs = require('fs');

const ALICE = '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY';
const DOT = new BN('1000000000000000');

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
        jest.setTimeout(25000);

        const provider = new WsProvider('ws://127.0.0.1:9944');
        api = await ApiPromise.create({ provider });

        const keyring = testKeyring.default();
        const alicePair = keyring.getPair(ALICE);
        testOrigin = keyring.addFromSeed(randomAsU8a(32));

        // Send 200 dots.
        let value = DOT.muln(500);
        await api.tx.balances.transfer(testOrigin.address, value)
            .signAndSend(alicePair, ({ status }) => {
                console.log('Transaction status:', status.type);
                if (status.isFinalized) {
                    done();
                }
            });
    });

    describe('flipper', () => {
        let codeHash;
        let abi;

        beforeEach(async (done) => {
            let flipperAbi = JSON.parse(
                fs.readFileSync('ink/examples/lang/flipper/target/old_abi.json')
            );
            abi = new Abi(flipperAbi);

            let flipperWasm = fs.readFileSync(
                'ink/examples/lang/flipper/target/flipper-pruned.wasm'
            )
            .toString('hex');

            await api.tx.contracts.putCode(500000, `0x${flipperWasm}`)
                .signAndSend(testOrigin, (result) => {
                    if (result.status.isFinalized) {
                        const record = result.findRecord('contracts', 'CodeStored');
                        if (record) {
                            codeHash = record.event.data[0];
                            done();
                        }
                    }
                });
        });

        test('flip', async (done) => {
            const CREATION_FEE = DOT.muln(200);
            const FLIP_FLAG_STORAGE_KEY = '0xeb72c87e65bed3596d6fef83aeb784615cdac1be1328adf1c7336acd6ba9ff77';
            await api.tx.contracts.create(CREATION_FEE, 500000, codeHash, abi.deploy())
                .signAndSend(testOrigin, async (result) => {
                    if (result.status.isFinalized) {
                        const record = result.findRecord('contracts', 'Instantiated');
                        if (record) {
                            let contractAddress = record.event.data[1];
                            console.log("address:", contractAddress);
                            // TODO: How to print ss58?

                            // Flip flag
                            let flipFlag = await getContractStorage(
                                api,
                                contractAddress,
                                FLIP_FLAG_STORAGE_KEY
                            );
                            console.log(flipFlag.unwrap());
                            expect(flipFlag.unwrap().toString()).toBe("0x00");

                            api.tx.contracts.call(contractAddress, 0, 500000, abi.messages.flip())
                                .signAndSend(testOrigin, async (result) => {
                                    if (result.status.isFinalized) {
                                        let flipFlag = await getContractStorage(
                                            api,
                                            contractAddress,
                                            FLIP_FLAG_STORAGE_KEY
                                        );
                                        expect(flipFlag.unwrap().toString()).toBe("0x01");
                                        done();
                                    }
                                });
                        }
                    }
                });
        });
    });

    describe('raw-incrementer', () => {
        let codeHash;

        beforeEach(async (done) => {
            let rawIncrementerWasm = fs.readFileSync(
                'contracts/raw-incrementer/target/raw_incrementer-pruned.wasm'
            )
            .toString('hex');

            await api.tx.contracts.putCode(500000, `0x${rawIncrementerWasm}`)
                .signAndSend(testOrigin, (result) => {
                    if (result.status.isFinalized) {
                        const record = result.findRecord('contracts', 'CodeStored');
                        if (record) {
                            codeHash = record.event.data[0];
                            done();
                        }
                    }
                });
        });

        test('raw incrementer', async (done) => {
            const CREATION_FEE = DOT.muln(200);

            await api.tx.contracts.create(CREATION_FEE, 500000, codeHash, '0x00')
                .signAndSend(testOrigin, async (result) => {
                    if (result.status.isFinalized) {
                        const record = result.findRecord('contracts', 'Instantiated');
                        if (record) {
                            let contractAddress = record.event.data[1];

                            // 0x00 0x2a 0x00 0x00 0x00 = Action::Inc(42)
                            let msg = '0x002a000000';

                            api.tx.contracts.call(contractAddress, 0, 500000, msg)
                                .signAndSend(testOrigin, async (result) => {
                                    if (result.status.isFinalized) {
                                        // The key actually is 0x010101..01. However, it seems to be
                                        // hashed before putting into the storage.
                                        const KEY = '0xf40ceaf86e5776923332b8d8fd3bef849cadb19c6996bc272af1f648d9566a4c';
                                        let counter = await getContractStorage(
                                            api,
                                            contractAddress,
                                            KEY
                                        );
                                        expect(counter.unwrap().toString()).toBe("0x2a000000");
                                        done();
                                    }
                                });
                        }
                    }
                });
        });
    });
});
