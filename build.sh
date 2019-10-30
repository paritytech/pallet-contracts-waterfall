#!/bin/bash

set -e

cd lib/ink/examples/lang/flipper
cargo contract build
cargo +nightly run -p abi-gen
cd -

cd contracts/rust/raw-incrementer
./build.sh
cd -

cd contracts/rust/restore-contract
./build.sh
cd -

cd contracts/assemblyscript/flipper
rm -rf build
rm yarn.lock # temporary workaround for "Error: Cannot find module 'ts-node'" Bug
yarn && yarn build
./build.sh
cd -

cd contracts/assemblyscript/incrementer
rm -rf build
rm yarn.lock # temporary workaround for "Error: Cannot find module 'ts-node'" Bug
yarn && yarn build
./build.sh
cd -