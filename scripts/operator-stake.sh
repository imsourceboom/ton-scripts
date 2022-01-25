#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

mytonctrl <<< "set stake 0"

ELECTION_STATE=$($SCRIPTS_DIR/ton-election-state.sh)
if [ $ELECTION_STATE != "ACTIVE" ]; then
	echo "NOT ELECTION"
	exit
fi

CURRENT_TIME=$(date +%s)
ELECTION_START=$($SCRIPTS_DIR/ton-election-start.sh)
if [ $(($CURRENT_TIME - $ELECTION_START)) -lt 100 ]; then
	echo "DONT VOTE YET"
	exit
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

sleep $((RANDOM % 200))
$SCRIPTS_DIR/operator-participate.sh
