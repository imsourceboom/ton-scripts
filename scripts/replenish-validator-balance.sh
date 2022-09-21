#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

BASE_AMOUNT=200
LIMIT_AMOUNT=100
VALIDATOR_BALANCE=$(mytonctrl <<< "wl" | grep "validator_wallet_001" | awk '{print $3}' | cut -d '.' -f 1)
GET_STAKE_VALUE=$(jq '.stake' $HOME/.local/share/mytoncore/mytoncore.db)


if [ $VALIDATOR_BALANCE -gt $LIMIT_AMOUNT ]; then
	echo "VALIDATOR BALANCE ENOUGH"
	if [ $GET_STAKE_VALUE = "null" ]; then
		echo $GET_STAKE_VALUE
		exit
	fi

	if [ $GET_STAKE_VALUE = "0" ]; then
		mytonctrl <<< "set stake null"
		echo $GET_STAKE_VALUE
	fi
	exit
fi

if [ $VALIDATOR_BALANCE -lt $LIMIT_AMOUNT ]; then
	ELECTION_STATE=$($SCRIPTS_DIR/ton-election-state.sh)
	if [ $ELECTION_STATE == "ACTIVE" ]; then
		echo "ELECTION $ELECTION_STATE"

		ELECTION_END_TIME=$($SCRIPTS_DIR/ton-election-end.sh)
		if [ $ELECTION_END_TIME -gt 0 ]; then
			LIMIT_TIME=7200
			CURRENT_TIME_UNIX=$(date -d "now" "+%s")
			REMAIN_TIME=$(($ELECTION_END_TIME - $CURRENT_TIME_UNIX))
	
			if [ $REMAIN_TIME -lt $LIMIT_TIME ]; then 
				if [ $GET_STAKE_VALUE = "0" ]; then
					mytonctrl <<< "set stake null"
					exit
				fi
			fi
		fi
	fi 

	echo "VALIDATOR BALANCE NOT ENOUGH"
	if [ $GET_STAKE_VALUE = "null" ]; then
		echo $GET_STAKE_VALUE
		mytonctrl <<< "set stake 0"
	fi

	POOL_ADDRESS=$(mytonctrl <<< "pools_list" | grep "active" | awk '$3 >= 300000 {print $4}')
	if [ "$POOL_ADDRESS" == "" ]; then
		echo "NOT RETURN POOL STAKE BALANCE"
		exit
	fi

	REPLENISH_AMOUNT=$(($BASE_AMOUNT - $VALIDATOR_BALANCE + 1))
	mytonctrl <<< "withdraw_from_pool validator_wallet_001 $POOL_ADDRESS $REPLENISH_AMOUNT"
fi
