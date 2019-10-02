#!/bin/bash

set -e

PROJNAME=incrementer

# wasm2wat -o build/$PROJNAME.wat build/wasm32-unknown-unknown/$PROJNAME.wasm
cat build/$PROJNAME.wat | sed "s/(import \"env\" \"memory\" (memory (;0;) 2))/(import \"env\" \"memory\" (memory (;0;) 2 16))/" > build/$PROJNAME-fixed.wat
wat2wasm -o build/$PROJNAME.wasm build/$PROJNAME-fixed.wat
wasm-prune --exports call,deploy build/$PROJNAME.wasm build/$PROJNAME-pruned.wasm
