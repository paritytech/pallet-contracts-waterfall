#!/bin/bash

set -e

PROJNAME=flipper

cat build/$PROJNAME.wat | sed "s/(import \"env\" \"memory\" (memory \$0 1))/(import \"env\" \"memory\" (memory \$0 16 16))/" > build/$PROJNAME-fixed.wat

wat2wasm build/$PROJNAME-fixed.wat -o build/$PROJNAME-fixed.wasm

wasm-prune --exports call,deploy build/$PROJNAME-fixed.wasm build/$PROJNAME-pruned.wasm

wasm2wat build/$PROJNAME-pruned.wasm -o build/$PROJNAME-pruned.wat