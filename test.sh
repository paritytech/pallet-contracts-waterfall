#!/bin/bash

# This file is being executed in the Gitlab CI and not intended to run locally.
# SUBSTRATE_PATH is defined in the `.gitlab-ci.yml file`
source utils.sh

set -evu

echo "_____Running dev node_____"
if [ -z "$SUBSTRATE_PATH" ]; then
    echo "Please specify the path to substrate in the SUBSTRATE_PATH environment variable"
    exit 1
elif [ ! -f "$SUBSTRATE_PATH" ]; then
    echo "$SUBSTRATE_PATH doesn't exist"
    exit 2
fi

$SUBSTRATE_PATH --version

echo "_____Purging dev chain_____"
$SUBSTRATE_PATH purge-chain --dev -y

echo "_____Spinning up the substrate node in background_____"
$SUBSTRATE_PATH --dev \
    &> substrate.log &

SUBSTRATE_PID=$!

echo "_____Updating PolkadotJS packages_____"
yarn upgrade --pattern @polkadot

echo "_____Executing tests_____"
yarn && yarn run test

echo "_____Kill the spawned substrate node_____"
kill -9 $SUBSTRATE_PID
