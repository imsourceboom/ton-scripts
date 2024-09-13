#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

DATE=$(date "+%F %a %T")
HOUR=$(echo $DATE | awk '{print $3}' | cut -d ':' -f 1)
MINUTE=$(echo $DATE | awk '{print $3}' | cut -d ':' -f 2)

$SCRIPTS_DIR/tg-timediff.sh
$SCRIPTS_DIR/tg-validate.sh
$SCRIPTS_DIR/tg-election.sh

if [ $HOUR -eq 10 -a $MINUTE -le 10 ]; then
	$SCRIPTS_DIR/tg-balance.sh
	$SCRIPTS_DIR/tg-db.sh
fi
