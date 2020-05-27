#!/bin/bash
source utils.sh

set -evu

provide-parity-tools
provide-wabt

echo "____Running ink! tests____"
if [[ -d lib/ink ]]; then
	git --git-dir lib/ink/.git pull origin master
else
	git clone --depth=1 --branch=master https://github.com/paritytech/ink.git lib/ink
fi

cd lib/ink/examples/flipper
cargo +nightly contract build
cargo +nightly contract generate-metadata
cd -

echo "____Running raw Rust Tests____"
cd contracts/rust/raw-incrementer
./build.sh
cd -

cd contracts/rust/restore-contract
./build.sh
cd -

echo "____Running Raw AssemblyScript Tests____"
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

