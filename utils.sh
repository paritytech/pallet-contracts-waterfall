#!/bin/bash

set -ev


function provide-parity-tools {
    if ! which cargo ; then
        curl https://sh.rustup.rs -sSf --default-toolchain | sh
        >&2 echo "Cargo is necessary for compiling these contracts"
    fi

    export PATH=~/.cargo/bin:$PATH

    cargo install cargo-contract

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

function provide-container {
    if which docker; then
        echo "Docker detected"
    else
        echo "Please install and run Docker to successfully run this script"
        exit 1
    fi

    if ! docker image exists "$1"; then
        docker image pull "$1"
    fi
}

function provide-solang {
    # we are good only with the latest or explicitly specified Solang
    if not-initialized "$SOLANG_PATH"; then
        solang_image="docker.io/hyperledgerlabs/solang:m6"
        provide-container $solang_image
        function solang { docker run -it --rm -v "$PWD":/x:z -w /x $solang_image; }
    else
        function solang { $SOLANG_PATH; }
    fi

    export -f solang
}
