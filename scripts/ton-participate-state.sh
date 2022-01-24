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

ELECTOR_PARTS_LIST=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR participant_list_extended")
ELECTIONS_OPEN=`echo $ELECTOR_PARTS_LIST | grep -F '0 0 0 0 () 0 0'`

if [[ -n $ELECTIONS_OPEN ]]; then
	echo "NOT ELECTION OPEN"
	exit
fi

RESULT_LIST=$(echo "$ELECTOR_PARTS_LIST" | grep -i 'result:' | tr "]]" "\n" | tr '[' '\n' | awk 'NF > 0')
RESULT_ELECTION_ID=$(echo "$ELECTOR_PARTS_LIST" | awk -F 'result:' '{print $2}' | awk '{print $2}')

if [ $RESULT_ELECTION_ID == $ELECTIONS_ID ]; then
	CONFIG_JSON=$(cat /var/ton-work/db/config.json)
	VALIDATORS_COUNT=$(echo $CONFIG_JSON | jq ".validators|length")

	for (( i = 0; i < $VALIDATORS_COUNT; i++ ))
	do
		ADNL_ID=$(echo $CONFIG_JSON | jq -r ".validators[$i].adnl_addrs[0].id")
		ADNL_HEX=$($SCRIPTS_DIR/base64-to-hex.sh $ADNL_ID)
		ADNL_DEC=$($SCRIPTS_DIR/hex2dec.sh $ADNL_HEX)
		FOUND=$(echo "$RESULT_LIST" | grep $ADNL_DEC)
		STAKE=$(echo $FOUND | awk '{print $1}')
		ADNL_FROM_ELECTOR=$(echo $FOUND | awk '{print $4}')

		if [ -z $ADNL_FROM_ELECTOR ]; then
			echo "NOT_FOUND"
			exit
		else
			echo "ACTIVE"
			exit
		fi
	done
fi

echo "NOT_FOUND"
