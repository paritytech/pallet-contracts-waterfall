# pallet-contracts test site

This repo hosts tests for `pallet-contracts`.

# Preparations

For running this test suite you would need to have:

1. A nightly rust compiler equipped with the `wasm32-unknown-unknown` target.

   The easiest way to install it is with `rustup`. Please see https://rustup.rs.

   ```shell
   rustup toolchain install nightly
   rustup update
   rustup target add wasm32-unknown-unknown --toolchain nightly
   rustup component add rust-src --toolchain nightly
   ```

   Also, you might need to put cargo's bin directory on PATH. You can typically do it by executing:

   ```shell
   source ~/.cargo/env
   ```

2. Yarn.

   Read on how to install it [here](https://yarnpkg.com/lang/en/docs/install/).

3. JavaScript test environment

   To install all depenmdencies used by the Jest testing suite, run the following command:

   `yarn`

   To upgrade to the latest versions of the Polkadot JS dependencies, run the following command:

   `yarn upgrade --pattern @polkadot`

4. Initialize submodules

   This repo depends on submomdules, make sure you have them:

   ```
   git submodule update --init
   ```

   If you were running this test suite before and want to update your local version to the latest master branches of the submodules, run:

   ```
   git submodule update --remote --merge
   ```

# Compiling the examples

To build all artifacts required for running the tests, you need to invoke

```
./build.sh
```

This will also install https://github.com/WebAssembly/wabt on your computer.

## Optional Solang test relying on Docker:

The recommended way to install Solang is currently to use the latest docker image from https://hub.docker.com/r/hyperledgerlabs/solang/tags.
For this reason, the Solang tests-cases will only be compiled by running the `build.sh` script if Docker is installed and running on your machine.
Alternatively you can also install Solang manually on your local machine.

Please see https://github.com/hyperledger-labs/solang for details.

# Execute tests

To run the tests, launch the substrate node locally and run

```
yarn test
```

## To only run a language specific subset of tests, the following commands are available:

**Run AssemblyScript tests only:**
`yarn test:as`

**Run Rust and ink! tests only:**
`yarn test:rust`

**Run Solang tests only:**
`yarn test:solang`

# Using a Docker image of Substrate for testing

To run this tests, you need to run a local Substrate on port `ws://127.0.0.1:9944`. The other alternative is to use one of the Docker images that are being automatically generated with every update to the master branch and published https://hub.docker.com/r/parity/substrate/.

The script to run this container is `docker-compose.yml` file in the root of this repository.

Before you can run this script, you need to install Docker and 'Docker Compose' on your machine.
Please follow the steps described here (including the prerequisites): https://docs.docker.com/compose/install/

Usage:

1. BUILD: Run `docker-compose pull && docker-compose up` to pull the latest docker imaged and run the Docker image of the latest Subtrate master.
2. INFO: Run `docker ps` to get a list of Docker containers running in the background including their mapped ports on localhost
3. QUIT: Run `docker-compose down` to stop and remove all running containers.

Provided endpoint for localhost: Substrate Master ws://127.0.0.1:9944/

Find more Docker images of Substrate https://hub.docker.com/r/parity/substrate/tags
