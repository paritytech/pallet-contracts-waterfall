const { ApiPromise, WsProvider, Bytes } = require('@polkadot/api');
const { Abi } = require('@polkadot/api-contract');
const Rpc = require('@polkadot/rpc-core').default;
const testKeyring = require('@polkadot/keyring/testing');
const { randomAsU8a } = require('@polkadot/util-crypto');
const BN = require('bn.js');
const fs = require('fs');

const ALICE = '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY';
const DOT = new BN('1000000000000000');

async function getContractStorage(api, rpc, contractAddress, storageKey) {
    let contractInfo = await api.query.contracts.contractInfoOf(contractAddress);
    let trieId = contractInfo.unwarp().asAlive.trieId;
    return await rpc.state.getChildStorage(trieId, storageKey).toPromise();
}

describe('simplest contract', () => {
    // This is a test account that is going to be created and funded each test.
    let testOrigin;
    let api;
    let rpc;

    beforeEach(async (done) => {
        jest.setTimeout(25000);

        const provider = new WsProvider('ws://127.0.0.1:9944');
        api = await ApiPromise.create({ provider });
        rpc = new Rpc(provider);

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
                                 rpc,
                                 contractAddress,
                                 '0xeb72c87e65bed3596d6fef83aeb784615cdac1be1328adf1c7336acd6ba9ff77'
                            );
                            console.log(flipFlag); // should be 0

                            done(); // TODO: Remove

                            // 5G5YthgPLGcHkjp9Q5SFLuV6kD7T3S25W1wSxEWaRaVUy1Vj

                            // api.tx.contracts.call(contractAddress, 0, 500000, abi.messages.flip())
                            //     .signAndSend(testOrigin, (result) => {
                            //         if (result.status.isFinalized) {
                            //             // need to call get child storage with
                            //             // 1. trie_id
                            //             // 2. the key
                            //             //
                            //             // the key can be hardcoded,
                            //             // the child storage id can be obtained by a contract address.

                            //             // TODO: Verify that the state is actually flipped.
                            //             done();
                            //         }
                            //     });
                        }
                    }
                });
        });
    });
});
