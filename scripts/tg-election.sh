#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

ELECTION_STATE=$($SCRIPTS_DIR/ton-election-state.sh)
if [ $ELECTION_STATE != "ACTIVE" ]; then
	echo "NOT ELECTION"
	exit
fi

CURRENT_TIME=$(date +%s)
ELECTION_START=$($SCRIPTS_DIR/ton-election-start.sh)
if [ $(($CURRENT_TIME - $ELECTION_START)) -lt 7200 ]; then
	echo "NOT CHECK TIME"
	exit
fi

ELECTION_END=$($SCRIPTS_DIR/ton-election-end.sh)
ELECTION_END_HUMAN=$(date --date="@$ELECTION_END" "+%F %a %T")
if [ $(($ELECTION_END - $CURRENT_TIME)) -lt 600 ]; then
	echo "NOT CHECK TIME"
	exit
fi

PARTICIPATE=$($SCRIPTS_DIR/ton-participate-state.sh)
if [ $PARTICIPATE != "ACTIVE" ]; then
	MESSAGE="‼️ Not in Election%0AElection END: $ELECTION_END_HUMAN"
	$TG_SEND_ALARM "unique" "$MESSAGE" 2>&1 > /dev/null
fi
