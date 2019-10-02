#!/bin/bash

set -e

cd ink/examples/lang/flipper
./build.sh
cargo +nightly build --features ink-generate-abi
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