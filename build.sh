#!/bin/bash

set -e

cd contracts/rust/lang-flipper
cargo contract build
cargo +nightly run -p abi-gen
cd -

cd contracts/rust/raw-incrementer
./build.sh
cd -

cd contracts/rust/restore-contract
./build.sh
cd -

cd contracts/assemblyscript/incrementer
rm -rf build
yarn && yarn build
./build.sh
cd -