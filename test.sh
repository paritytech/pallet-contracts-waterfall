#!/bin/bash

# You can set following variables:
# SUBSTRATE_PATH for running your local Substrate instead of the containerized one
# SUBSTRATE_WS_PORT to change WebSockets port if it is already occupied
# SUBSTRATE_HTTP_PORT to change HTTP port if it is already occupied

source utils.sh

set -evu

echo "_____Running dev node and tests_____"
if not-initialized "$SUBSTRATE_PATH"; then
    provide-container \
        "parity/substrate:latest" \
        "Please specify the path to substrate in the SUBSTRATE_PATH environment variable"

    SUBSTRATE_PATH=""
else
    $SUBSTRATE_PATH --version
fi

if [ -z $SUBSTRATE_WS_PORT ]; then
    SUBSTRATE_WS_PORT=9944
fi
if [ -z $SUBSTRATE_HTTP_PORT ]; then
    SUBSTRATE_HTTP_PORT=9933
fi


# Purge dev chain and then spin up the substrate node in background
if [ -z "$SUBSTRATE_PATH" ]; then
    echo "_____Spinning up fresh substrate container in background_____"
    SUBSTRATE_CID=$($DOCKER run -dt --rm \
      -p $SUBSTRATE_WS_PORT:9944 \
      -p $SUBSTRATE_HTTP_PORT:9933 \
      substrate:latest --dev \
      --ws-external --rpc-external)
else
    echo "_____Purging dev chain_____"
    $SUBSTRATE_PATH purge-chain --dev -y

    echo "_____Spinning up the substrate node in background_____"
    $SUBSTRATE_PATH --dev \
      --ws-port $SUBSTRATE_WS_PORT \
      --rpc-port $SUBSTRATE_HTTP_PORT \
      &> substrate.log &
    SUBSTRATE_PID=$!
fi

echo "_____Updating PolkadotJS API_____"
yarn upgrade --pattern @polkadot
echo "_____Executing tests_____"
yarn && yarn test

echo "_____Kill the spawned substrate node_____"
if [ -z "$SUBSTRATE_PATH" ]; then
    $DOCKER stop $SUBSTRATE_CID 
else
    kill -9 $SUBSTRATE_PID
fi
