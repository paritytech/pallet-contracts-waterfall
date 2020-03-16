#!/bin/bash

set -evu

echo "_____Running dev node and tests_____"
if [ -z "$SUBSTRATE_PATH" ]; then
    echo "Please specify the path to substrate in the SUBSTRATE_PATH environment variable"
    exit 1
fi

if [ ! -f "$SUBSTRATE_PATH" ]; then
    echo "$SUBSTRATE_PATH doesn't exist"
    exit 2
fi

$SUBSTRATE_PATH --version

echo "_____Purging dev chain_____"
$SUBSTRATE_PATH purge-chain --dev -y
echo "_____Spinning up the substrate node in background_____"
$SUBSTRATE_PATH --dev &
SUBSTRATE_PID=$!

echo "_____Updating PolkadotJS API_____"
yarn upgrade --pattern @polkadot
echo "_____Executing tests_____"
yarn && yarn test

echo "_____Kill the spawned substrate node_____"
kill -9 $SUBSTRATE_PID
