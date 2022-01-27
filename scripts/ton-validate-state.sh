#!/bin/bash

. env.sh

CONFIG_JSON=$(cat /var/ton-work/db/config.json)
VALIDATORS_COUNT=$(echo $CONFIG_JSON | jq ".validators|length")

if [ $VALIDATORS_COUNT = 0 ]; then
	echo "NO_VALIDATOR_ADNL"
	exit
fi

if [ $VALIDATORS_COUNT -gt 0 ]; then
	for (( i = 0; i < $VALIDATORS_COUNT; i++ ))
	do
		ADNL_ID=$(echo $CONFIG_JSON | jq -r ".validators[$i].adnl_addrs[0].id")
		ADNL_ID_HEX=$($SCRIPTS_DIR/base64-to-hex.sh $ADNL_ID)
		FIND_ADNL=$($LITE_CLIENT "getconfig 34" | grep $ADNL_ID_HEX | awk -F 'adnl_addr:' '{print $2}' | tr -d 'x)')
		
		if [ -z $FIND_ADNL ]; then
			echo "NOT_VALIDATE"
			exit
		else
			echo "ACTIVE"
			exit
		fi
	done
fi

echo "NOT_VALIDATE"
