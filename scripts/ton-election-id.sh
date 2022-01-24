#!/bin/bash

. env.sh

ELECTION_ID=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR active_election_id" | grep 'result:' | cut -f 2 -d : | tr -d '[ ]')

if [ -z $ELECTION_ID ]; then
	echo "-1"
	exit
fi

echo $ELECTION_ID
