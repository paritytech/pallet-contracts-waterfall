#!/bin/bash

# You can set following variables:
# SUBSTRATE_PATH for running your local Substrate instead of the containerized one
# SUBSTRATE_WS_PORT to change WebSockets port if it is already occupied
# SUBSTRATE_HTTP_PORT to change HTTP port if it is already occupied

source utils.sh

set -e

echo "_____Running dev node and tests_____"
# We are good only with explicitly specified or containerized Substrate
if not-initialized "$SUBSTRATE_PATH"; then
    provide-container \
        "docker.io/parity/substrate:latest" \
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

echo "_____Updating PolkadotJS API_____"
yarn upgrade --pattern @polkadot

if [ -z "$SUBSTRATE_PATH" ]; then
    echo "_____Spinning up fresh substrate container in background_____"
    SUBSTRATE_CID=$($DOCKER run -dt --rm \
      -p $SUBSTRATE_WS_PORT:9944 \
      -p $SUBSTRATE_HTTP_PORT:9933 \
      parity/substrate:latest --dev \
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

function stop_substrate {
    if [ -z "$SUBSTRATE_PID" ]; then
        if [ ! -z "$SUBSTRATE_CID" ]; then 
            echo "_____Stopping the launched substrate container_____"
            $DOCKER stop $SUBSTRATE_CID
            SUBSTRATE_CID=""
        fi
    else
        echo "_____Killing the spawned substrate process_____"
        kill -9 $SUBSTRATE_PID
    fi
}

function ctrl_c_handler {
    stop_substrate $path
}

trap ctrl_c_handler INT

echo "_____Executing tests_____"
yarn && yarn test -w 2 $@

stop_substrate
