#!/bin/bash

export NODE_OPTIONS="--max-old-space-size=8192"
export WABT_PATH
export SOLANG_PATH
source utils.sh

set -ev

provide-parity-tools

if which podman || which docker || [ -n "$CI_JOB_ID" ]; then
    provide-wabt
    provide-solang
    cd contracts/solidity/flipper
    ./build.sh
    cd -; 
else echo "Please install and run Docker or Podman if you want to compile the Solang contracts and succesfully run their tests.";
fi

if [[ -d lib/ink ]]; then
	git --git-dir lib/ink/.git pull origin master
else
	git clone --depth=1 --branch=master https://github.com/paritytech/ink.git lib/ink
fi

cd lib/ink/examples/flipper
cargo +nightly contract build
cargo +nightly contract generate-metadata
cd -

cd contracts/rust/raw-incrementer
./build.sh
cd -

cd contracts/rust/restore-contract
./build.sh
cd -

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
