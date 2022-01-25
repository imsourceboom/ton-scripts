#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

mytonctrl <<< "set stake 0"

CURRENT_TIME=$(date +%s)
ELECTION_STATE=$($SCRIPTS_DIR/ton-election-state.sh)
ELECTION_START=$($SCRIPTS_DIR/ton-election-start.sh)
ELECTION_END=$($SCRIPTS_DIR/ton-election-end.sh)
PARTICIPATE=$($SCRIPTS_DIR/ton-participate-state.sh)

if [ $ELECTION_STATE != "ACTIVE" ]; then
	echo "NOT ELECTION"
	exit
fi

if [ $(($CURRENT_TIME - $ELECTION_START)) -lt 100 ]; then
	echo "DONT VOTE YET"
	exit
fi

if [ $CURRENT_TIME -gt $ELECTION_END ]; then
	echo "ELECTION END"
	exit
fi

if [ $PARTICIPATE = "ACTIVE" ]; then
	echo "Already Participated"
	exit
fi

sleep $((RANDOM % 200))
$SCRIPTS_DIR/operator-participate.sh
