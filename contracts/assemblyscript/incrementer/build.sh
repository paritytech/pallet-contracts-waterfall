#!/bin/bash

set -e

PROJNAME=incrementer

cat build/$PROJNAME.wat | sed "s/(import \"env\" \"memory\" (memory \$0 1))/(import \"env\" \"memory\" (memory \$0 2 16))/" > build/$PROJNAME-fixed.wat

cat build/$PROJNAME-fixed.wat | sed "/(import \"env\" \"abort\" (func \$~lib\/builtins\/abort (param i32 i32 i32 i32)))/d" > build/$PROJNAME-trap.wat

cat build/$PROJNAME-trap.wat | sed "/call $~lib\/builtins\/abort/d" > build/$PROJNAME-trap2.wat

wat2wasm -o build/$PROJNAME-trap2.wasm build/$PROJNAME-trap2.wat

wasm-prune --exports call,deploy build/$PROJNAME-trap2.wasm build/$PROJNAME-pruned.wasm
