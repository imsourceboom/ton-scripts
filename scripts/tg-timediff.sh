#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

TIMEDIFF=$($SCRIPTS_DIR/ton-check-sync.sh | grep TIME_DIFF | cut -d '=' -f 2)

if [ $TIMEDIFF -gt 0 ] || [ $TIMEDIFF -lt -100 ]; then
	MESSAGE="🕞 Sync off, SYNC: $TIMEDIFF"
	$TG_SEND_ALARM "normal" "$MESSAGE" 2>&1 > /dev/null
fi


