#!/bin/bash

if [ -z "$SUBSTRATE_PATH" ]; then
    echo "Please specify the path to substrate in the SUBSTRATE_PATH environment variable"
    exit 1
fi

if [ ! -f "$SUBSTRATE_PATH" ]; then
    echo "$SUBSTRATE_PATH doesn't exist"
    exit 2
fi

# Purge dev chain and then spin up the substrate node in background
$SUBSTRATE_PATH purge-chain --dev -y
$SUBSTRATE_PATH --dev &
SUBSTRATE_PID=$!

# Execute tests
yarn && yarn test

# Kill the spawned substrate node
kill -9 $SUBSTRATE_PID
