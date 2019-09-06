
# srml-contracts test site

This repo hosts tests for `srml-contracts`.

# Preparations

For running this test suite you would need to have:

1. A nightly rust compiler equipped with the `wasm32-unknown-unknown` target.

    The easiest way to install it is with `rustup`. Please see https://rustup.rs.

    ```shell
    rustup toolchain install nightly
    rustup update
    rustup target add wasm32-unknown-unknown --toolchain nightly
    ```

    Also, you might need to put cargo's bin directory on PATH. You can typically do it by executing:

    ```shell
    source ~/.cargo/env
    ```

2. yarn.

    Read on how to install it [here](https://yarnpkg.com/lang/en/docs/install/).


3. wasm-prune

    ```shell
    cargo install pwasm-utils-cli --bin wasm-prune
    ```

4. wabt

    You can try to look it up in the package manager for your system or
    build it yourself.

    Please see https://github.com/WebAssembly/wabt for details.

# Running

This repo depends on submomdules, make sure you have them:

```
git submodule update --init
```

Then make sure that you built all artifacts required for running the tests by invoking

```
./build.sh
```

To run the tests, launch the substrate node locally and run

```
yarn && yarn test
```
