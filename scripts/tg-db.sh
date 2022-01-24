#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

DB=$(ton-remain-disk.sh | tr -d 'G')

if [ $DB -le 50 ]; then
	MESSAGE="💾 Remain Disk Space: ${DB}G"
	$TG_SEND_ALARM "unique" "$MESSAGE" 2>&1 > /dev/null
fi
