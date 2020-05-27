#!/bin/bash

set -ev

function not-initialized {
    if [ -n "$1" ] && [ ! -f "$1" ]; then
        >&2 echo "$1 doesn't exist"
        # the path is incorrect
        exit 2 
    fi

    if [ -z "$1" ]; then
        # we can perform auto-initialization
        return 0
    fi

    # the variable is correctly initialized
    return 125 
}


function provide-parity-tools {
    if ! which cargo ; then
        curl https://sh.rustup.rs -sSf --default-toolchain | sh
        >&2 echo "Cargo is necessary for compiling these contracts"
    fi

    export PATH=~/.cargo/bin:$PATH

    if ! which cargo-contract; then
        cargo install cargo-contract
    fi

    if ! which wasm-prune; then
        cargo install pwasm-utils-cli --bin wasm-prune
    fi
}

function provide-wabt {
    if ! which wasm2wat && ! which wat2wasm; then
        if [[ -d lib/wabt ]]; then
            git --git-dir lib/wabt/.git pull origin master
        else
            git clone --recursive --branch=master https://github.com/WebAssembly/wabt.git lib/wabt
            cd lib/wabt
            mkdir build
            cd build
            cmake ..
            cmake --build .
        fi
    fi
}


function provide-solang {
    # we are good only with the latest Solang
    # https://hub.docker.com/r/hyperledgerlabs/solang/tags
    if not-initialized "$SOLANG_PATH"; then
        export solang_image="docker.io/hyperledgerlabs/solang:latest"
        docker image pull $solang_image
        function solang { docker run -it --rm -v "$PWD":/x:z -w /x $solang_image "$@"; }
    else
        function solang { $SOLANG_PATH "$@"; }
    fi

    export -f solang
}