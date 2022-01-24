#!/bin/bash

TON_DIR="/usr/bin/ton"
LITE_CLIENT="$TON_DIR/lite-client/lite-client"
LITE_PORT=$(cat /var/ton-work/db/config.json | jq -r ".liteservers[0].port")
LITE_CONFIG="-p /var/ton-work/keys/liteserver.pub -a 127.0.0.1:$LITE_PORT -t 5"
#GLOBAL_CONFIG="-C $TON_DIR/global.config.json"

$LITE_CLIENT $LITE_CONFIG -rc "$1" -rc "quit" 2>/dev/null
#$LITE_CLIENT $GLOBAL_CONFIG -rc "$1" -rc 'quit' 2>/dev/null
