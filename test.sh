#!/bin/bash

# You can set following variables:
# SUBSTRATE_PATH for running your local Substrate instead of the containerized one
# SUBSTRATE_WS_PORT to change WebSockets port if it is already occupied
# SUBSTRATE_HTTP_PORT to change HTTP port if it is already occupied

source utils.sh

set -evu

# defaults
: "${SUBSTRATE_HTTP_PORT:=9933}"
: "${SUBSTRATE_WS_PORT:=9944}"

echo "_____Updating PolkadotJS API_____"
yarn upgrade --pattern @polkadot

echo "_____Running dev node_____"
# We are good only with explicitly specified or containerized Substrate
if not-initialized "${SUBSTRATE_PATH:+$SUBSTRATE_PATH}"; then
    echo "_____Spinning up fresh substrate container in background_____"

    provide-container \
        "docker.io/parity/substrate:latest" \
        "Please specify the path to substrate in the SUBSTRATE_PATH environment variable"

    SUBSTRATE_CID=$($DOCKER run -dt --rm \
      -p $SUBSTRATE_WS_PORT:9944 \
      -p $SUBSTRATE_HTTP_PORT:9933 \
      parity/substrate:latest --dev \
      --ws-external --rpc-external)

    SUBSTRATE_PID=""
else
    $SUBSTRATE_PATH --version

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
    echo "_____Quitting test system_____"
    if [ -z "$SUBSTRATE_PID" ]; then
        if [ -n "$SUBSTRATE_CID" ]; then 
            echo "_____Stopping the launched substrate container_____"
            $DOCKER stop "$SUBSTRATE_CID"
            SUBSTRATE_CID=""
        fi
    else
        echo "_____Killing the spawned substrate process_____"
        kill -9 $SUBSTRATE_PID
    fi
}

# in bash, EXIT includes INT (ctr+c), but it is not the case in sh
trap stop_substrate EXIT

echo "_____Executing tests_____"
yarn && yarn test -w 2 "$@"
