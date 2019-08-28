const { ApiPromise, WsProvider, Bytes } = require('@polkadot/api');
const { Abi } = require('@polkadot/api-contract');
const testKeyring = require('@polkadot/keyring/testing');
const { randomAsU8a } = require('@polkadot/util-crypto');
const BN = require('bn.js');
const fs = require('fs');

const ALICE = '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY';

const DOT = new BN('1000000000000000');

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
            .signAndSend(alicePair, ({ events = [], status }) => {
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
            await api.tx.contracts.create(CREATION_FEE, 500000, codeHash, abi.deploy())
                .signAndSend(testOrigin, (result) => {
                    if (result.status.isFinalized) {
                        const record = result.findRecord('contracts', 'Instantiated');
                        if (record) {
                            let contractAddress = record.event.data[1];
                            console.log("address:", contractAddress);

                            api.tx.contracts.call(contractAddress, 0, 500000, abi.messages.flip())
                                .signAndSend(testOrigin, (result) => {
                                    if (result.status.isFinalized) {
                                        // TODO: Verify that the state is actually flipped.
                                        done();
                                    }
                                });
                        }
                    }
                });
        });
    });
});
