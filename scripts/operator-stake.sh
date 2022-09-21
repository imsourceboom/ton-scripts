#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

GET_STAKE_VALUE=$(jq '.stake' $HOME/.local/share/mytoncore/mytoncore.db)

if [ $GET_STAKE_VALUE != "0" ]; then
	mytonctrl <<< "set stake 0"
fi

ELECTION_STATE=$($SCRIPTS_DIR/ton-election-state.sh)
if [ $ELECTION_STATE != "ACTIVE" ]; then
	echo "NOT ELECTION"
	exit
fi

CURRENT_TIME=$(date +%s)
ELECTION_START=$($SCRIPTS_DIR/ton-election-start.sh)
if [ $(($CURRENT_TIME - $ELECTION_START)) -lt 10 ]; then
	echo "DONT VOTE YET"
	sleep $((RANDOM % 11 + 10))
fi

ELECTION_END=$($SCRIPTS_DIR/ton-election-end.sh)
if [ $CURRENT_TIME -gt $ELECTION_END ]; then
	echo "ELECTION END"
	exit
fi

PARTICIPATE=$($SCRIPTS_DIR/ton-participate-state.sh)
if [ $PARTICIPATE = "ACTIVE" ]; then
	echo "Already Participated"
	exit
fi

sleep $((RANDOM % 11 + 10))
$SCRIPTS_DIR/operator-participate.sh
