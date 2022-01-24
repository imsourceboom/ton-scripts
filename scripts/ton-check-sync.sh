#!/bin/bash

. env.sh

PORT=$(cat /var/ton-work/db/config.json | jq -r ".control[0].port")
TON_BUILD_DIR="/usr/bin/ton"
KEYS_DIR="/var/ton-work/keys"

TIME_DIFF=0

$CONSOLE "getstats"

for i in $($CONSOLE "getstats" 2>&1 | grep time | awk '{print $2}');
do
	TIME_DIFF=$((i - TIME_DIFF))
done

#"${TON_BUILD_DIR}/validator-engine-console/validator-engine-console" \
#    -a "127.0.0.1:$PORT"  \
#    -k "${KEYS_DIR}/client" \
#    -p "${KEYS_DIR}/server.pub" \
#    -c "getstats" -c "quit"

#for i in $("${TON_BUILD_DIR}/validator-engine-console/validator-engine-console" \
#    -a "127.0.0.1:$PORT" \
#    -k "${KEYS_DIR}/client" \
#    -p "${KEYS_DIR}/server.pub" \
#    -c "getstats" -c "quit" 2>&1 | grep time | awk '{print $2}'); do
#    TIME_DIFF=$((i - TIME_DIFF))
#done

echo "INFO: TIME_DIFF = ${TIME_DIFF}"
