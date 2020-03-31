#!/bin/bash

export WABT_PATH
export SOLANG_PATH
source utils.sh

set -ev

provide-parity-tools

if which podman || docker info; then
    provide-wabt
    provide-solang
    cd contracts/solidity/flipper
    ./build.sh
    cd -; 
else echo "Please install and run Docker or Podman if you want to compile the Solang contracts and succesfully run their tests.";
fi

cd lib 
git submodule foreach git pull origin master
cd ink/examples/flipper
cargo +nightly contract build
cargo +nightly contract generate-metadata
cd -

provide-wabt

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
