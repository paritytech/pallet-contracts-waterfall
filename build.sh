#!/bin/bash
source utils.sh

set -ev

provide-parity-tools
provide-wabt

## Solang Tests
if which docker || [ -n "$CI_JOB_ID" ]; then
    provide-solang
    cd contracts/solidity/flipper
    ./build.sh
    cd -; 
else 
    echo "Please install and run Docker if you want to compile the Solang contracts and succesfully run their tests.";
fi

## ink! Tests
if [[ -d lib/ink ]]; then
	git --git-dir lib/ink/.git pull origin master
else
	git clone --depth=1 --branch=master https://github.com/paritytech/ink.git lib/ink
fi

cd lib/ink/examples/flipper
cargo +nightly contract build
cargo +nightly contract generate-metadata
cd -

## Raw Rust Tests
cd contracts/rust/raw-incrementer
./build.sh
cd -

cd contracts/rust/restore-contract
./build.sh
cd -

## Raw AssemblyScript Tests
cd contracts/assemblyscript/flipper
rm -rf build
yarn
yarn build
./build.sh
cd -

cd contracts/assemblyscript/incrementer
rm -rf build
yarn
yarn build
./build.sh
cd -

cd contracts/assemblyscript/erc20
rm -rf build
yarn
yarn build
./build.sh
cd -
