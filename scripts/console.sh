#!/bin/bash

TON_DIR="/usr/bin/ton"
KEYS_DIR="/var/ton-work/keys"
CONSOLE="$TON_DIR/validator-engine-console/validator-engine-console"
CONSOLE_PORT=$(cat /var/ton-work/db/config.json | jq -r ".control[0].port")
CONSOLE_CONFIG="-a 127.0.0.1:$CONSOLE_PORT -k $KEYS_DIR/client -p $KEYS_DIR/server.pub -t 5"

$CONSOLE $CONSOLE_CONFIG -c "$1" -c "quit" 2>/dev/null

#$TON_BUILD_DIR/validator-engine-console/validator-engine-console \
#	-a 127.0.0.1:$CONSOLE_PORT \
#	-k $KEYS_DIR/client \
#	-p $KEYS_DIR/server.pub \
#	-t 5 \
#	-c "$1" -c "quit" 2>/dev/null
