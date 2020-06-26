#!/bin/bash

export SOLANG_PATH
source utils.sh

set -evu

provide-parity-tools
provide-wabt

echo "____Building Solang Examples____"
## Solang installation depends on docker locally and is pre-installed in the CI
if which docker || [ -n "$CI_JOB_ID" ]; then
    provide-solang
    cd contracts/solidity/flipper
    ./build.sh
    cd -;
    cd contracts/solidity/creator
    ./build.sh
    cd -;
else 
    echo "Please install and run Docker if you want to compile the Solang contracts and succesfully run their tests."; 
fi

echo "____Building ink! Examples____"
if [[ -d lib/ink ]]; then
    cd lib/ink
    git pull origin master
    cd -
else
	git clone https://github.com/paritytech/ink.git lib/ink
fi

cd lib/ink/examples/flipper
cargo +nightly contract build
cargo +nightly contract generate-metadata
cd -

echo "____Building raw Rust Examples____"
cd contracts/rust/raw-incrementer
./build.sh
cd -

cd contracts/rust/restore-contract
./build.sh
cd -

echo "____Building AssemblyScript examples____"
if [[ -d lib/as-substrate ]]; then
    cd lib/as-substrate/
    git pull origin master
    cd -
else
	git clone https://github.com/paritytech/as-substrate.git lib/as-substrate
fi

cd lib/as-substrate
yarn clean
yarn
yarn build
cd -