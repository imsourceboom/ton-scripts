#!/bin/bash

. env.sh

ELECTION_STATE=$(ton-election-state.sh)
if [ $ELECTION_STATE != "ACTIVE" ]; then
	echo "NOT_ELECTION"
        exit
fi

ELECTIONS_ID=$(ton-election-id.sh)
if [ $ELECTIONS_ID = "-1" ]; then
	echo "ERROR: Can't get election date"
	exit
fi

if [ $ELECTIONS_ID = "0" ]; then
	echo "NOT_ELECTION";
	exit
fi

ELECTION_ENTRY="/tmp/mytoncore/${ELECTIONS_ID}_ElectionEntry.json"
if [ ! -f $ELECTION_ENTRY ]; then
	echo "Not exist JSON file"
	exit
fi

VALIDATOR_PUBKEY="0x$(cat $ELECTION_ENTRY | jq -r ".validatorPubkey" | tr [:upper:] [:lower:])"
PARTICIPATES_IN=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR participates_in $VALIDATOR_PUBKEY" | grep "result" | awk '{print $3}')

if [ $PARTICIPATES_IN = 0 ]; then
	echo "NOT_FOUND"
	exit
fi

echo $PARTICIPATES_IN
echo "ACTIVE"
