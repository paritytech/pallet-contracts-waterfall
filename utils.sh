#!/bin/bash

set -e

function provide-container {
    if which docker; then
        echo "Docker detected"
        export DOCKER="sudo docker"
    else
        >&2 echo "$2"
        >&2 echo "OR install Docker (you can also use Podman with DOCKER=podman)"
        exit 1
    fi

    if ! $DOCKER image exists "$1"; then
        $DOCKER image pull "$1"
    fi
}

function not-initialized {
    if [ -n "$1" ] && [ ! -f "$1" ]; then
        >&2 echo "$1 doesn't exist"
        exit 2 # user pretends to know what he is doing,
               # but the path is incorrect
    fi

    if [ -z "$1" ]; then
        # we can perform auto-initialization
        return 0
    fi

    # the variable is correctly initialized
    return 125 
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
    # we are good only with the latest or explicitly specified Solang
    if not-initialized "$SOLANG_PATH"; then
        export solang_image="docker.io/hyperledgerlabs/solang:m6"
        couldnt_find_message="Please specify the path to Solang in the SOLANG_PATH environment variable"

        provide-container $solang_image "$couldnt_find_message"

        function solang { $DOCKER run -it --rm -v "$PWD":/x:z -w /x $solang_image "$@"; }
    else
        function solang { $SOLANG_PATH "$@"; }
    fi

    export -f solang
}

function provide-parity-tools {
    if ! which cargo ; then
        >&2 echo "Cargo is necessary for compiling these contracts"
    fi

    export PATH=~/.cargo/bin:$PATH

    cargo install cargo-contract

    if ! which wasm-prune; then
        cargo install pwasm-utils-cli --bin wasm-prune
    fi
}
