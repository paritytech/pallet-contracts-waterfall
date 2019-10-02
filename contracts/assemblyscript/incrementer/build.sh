#!/bin/bash

set -e

PROJNAME=incrementer

cat build/$PROJNAME.wat | sed "s/(import \"env\" \"memory\" (memory \$0 1))/(import \"env\" \"memory\" (memory \$0 2 16))/" > build/$PROJNAME-fixed.wat

wat2wasm -o build/$PROJNAME-fixed.wasm build/$PROJNAME-fixed.wat

wasm-prune --exports call,deploy build/$PROJNAME-fixed.wasm build/$PROJNAME-pruned.wasm