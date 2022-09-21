#!/bin/bash

stakeValueFunc () {
	GET_STAKE_VALUE=$(jq '.stake' $HOME/.local/share/mytoncore/mytoncore.db)
	if [ $GET_STAKE_VALUE != "0" ]; then
		mytonctrl <<< "set stake 0"
	fi
}

stakeValueFunc
mytonctrl <<< ve
stakeValueFunc

sleep $((RANDOM % 11 + 10))

BALANCE=$(mytonctrl <<< wl | grep validator_wallet_001 | awk '{print $3}' | cut -d '.' -f 1)
RANDOM_DEDUCT=$((RANDOM % 5 + 3))
STAKE=$(($BALANCE - $RANDOM_DEDUCT))
MIN_STAKE=300000

if [ $STAKE -lt $MIN_STAKE ]; then
	echo "ERROR: Lack of Amount"
	stakeValueFunc
	exit
fi

mytonctrl <<< "set stake $STAKE"
mytonctrl <<< ve
mytonctrl <<< "set stake 0"
