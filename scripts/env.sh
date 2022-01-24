#!/bin/bash

SCRIPTS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
export SCRIPTS_DIR
TON_DIR=$(cd "${SCRIPTS_DIR}/../" && pwd -P)
export TON_DIR

export LITE_CLIENT="$SCRIPTS_DIR/lite-client.sh"
export CONSOLE="$SCRIPTS_DIR/console.sh"
export ELECTOR_ADDR="-1:$($LITE_CLIENT 'getconfig 1' | grep 'elector_addr' | cut -d ':' -f 2 | tr -d 'x)')"
export TG_SEND_ALARM="$SCRIPTS_DIR/tg-send-alarm.sh"

