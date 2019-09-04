#!/bin/bash

set -e

cd ink/examples/lang/flipper
./build.sh
cargo +nightly build --features ink-generate-abi
cd -

cd contracts/raw-incrementer
./build.sh
cd -

cd contracts/restore-contract
./build.sh
cd -
