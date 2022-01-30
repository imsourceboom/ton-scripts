#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

CONFIG_JSON=$(cat /var/ton-work/db/config.json)
VALIDATORS_COUNT=$(echo $CONFIG_JSON | jq ".validators | length")

if [ $VALIDATORS_COUNT = 0 ]; then
	echo "NO_VALIDATOR_ADNL"
	exit
fi

GETCONFIG_34=$($LITE_CLIENT "getconfig 34")
VALIDATORS_TOTAL_LIST=$(echo "$GETCONFIG_34" | grep "adnl_addr:x")
VALIDATORS_TOTAL_NUMBER=$(echo "$VALIDATORS_TOTAL_LIST" | wc -l)

if [ $VALIDATORS_COUNT -gt 0 ]; then
	for (( i = 0; i < $VALIDATORS_COUNT; i++ ))
	do
		ADNL_ID=$(echo $CONFIG_JSON | jq -r ".validators[$i].adnl_addrs[0].id")
		ADNL_ID_HEX=$($SCRIPTS_DIR/base64-to-hex.sh $ADNL_ID)

		for (( j = 1; j <= $VALIDATORS_TOTAL_NUMBER; j++ ))
		do
			ADNL_LIST=$(echo "$VALIDATORS_TOTAL_LIST" | awk "FNR == $j" | awk -F 'adnl_addr:x' '{print $2}' | tr -d ')')
			if [ $ADNL_LIST = $ADNL_ID_HEX ]; then
				echo "Validator index: $(($j - 1))"
				echo "ADNL addres: $ADNL_LIST"

				if [ $(($j - 1)) -lt 100 ]; then
					echo "Chain: Master"
					exit
				else
					echo "Chain: Shard"
					exit
				fi
			fi
		done
	done
fi
