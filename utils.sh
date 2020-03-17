#!/bin/bash

function provide-container {
    if which podman; then
        export DOCKER="podman"
    elif which docker; then
        "Docker detected, consider installing Podman to avoid typing a password"
        export DOCKER="sudo docker"
    else
        >&2 echo "$2"
        >&2 echo "OR install Docker (you can also use Podman with DOCKER=podman)"
        exit 1
    fi

    $DOCKER image pull $1
}

function not-initialized {
    if [ ! -z "$1" ] && [ ! -f "$1" ]; then
        >&2 echo "$1 doesn't exist"
        exit 2 #user pretends to know what he is doing
    fi

    if [ -z "$1" ]; then
        return 0 #we can try auto-initialization
    fi

    return 125 #the variable is initialized
}

function provide-wabt {
    if not-initialized "$WABT_PATH"; then
        provide-container \
            "kirillt/wabt:latest" \
            "Please specify the path to WABT in the WABT_PATH environment variable"

        function wasm2wat { $DOCKER run -it --rm -v $PWD:/src -w /src wabt wasm2wat $@; }
        function wat2wasm { $DOCKER run -it --rm -v $PWD:/src -w /src wabt wat2wasm $@; }
    else
        function wasm2wat { $WABT_PATH/bin/wasm2wat $@; }
        function wat2wasm { $WABT_PATH/bin/wat2wasm $@; }
    fi

    export -f wasm2wat
    export -f wat2wasm
}

export -f provide-wabt

function provide-solang {
    if not-initialized "$SOLANG_PATH"; then
        provide-container \
            "hyperledgerlabs/solang:latest" \
            "Please specify the path to Solang in the SOLANG_PATH environment variable"

        echo "|||| $DOCKER"

        function solang { $DOCKER run -it --rm -v $PWD:/src -w /src solang $@; }
    else
        function solang { $SOLANG_PATH $@; }
    fi

    export -f solang
}

function provide-parity-tools {
    if ! which cargo ; then
        >&2 echo "Cargo is necessary for compiling these contracts"
    fi

    export PATH=~/.cargo/bin:$PATH

    if ! which cargo-contract; then
        cargo install --git https://github.com/paritytech/cargo-contract.git
    fi

    if ! which wasm-prune; then
        cargo install --git https://github.com/paritytech/wasm-utils.git --bin wasm-prune
    fi
}

export -f provide-solang
