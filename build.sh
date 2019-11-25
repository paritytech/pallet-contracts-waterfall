#!/bin/bash

set -e

cd lib/ink/examples/lang2/flipper
cargo contract build
cargo contract generate-metadata
cd -

cd contracts/rust/raw-incrementer
./build.sh
cd -

cd contracts/rust/restore-contract
./build.sh
cd -

cd contracts/assemblyscript/flipper
rm -rf build
yarn && yarn build
./build.sh
cd -

cd contracts/assemblyscript/incrementer
rm -rf build
yarn && yarn build
./build.sh
cd -