#!/bin/bash

set -e

cd ink/examples/lang/flipper
./build.sh
cargo +nightly build --features ink-generate-abi
cd -

cd contracts-ink/raw-incrementer
./build.sh
cd -

cd contracts-ink/restore-contract
./build.sh
cd -

cd contracts-assemblyscript/increment
yarn && yarn build
cd -