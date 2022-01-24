#!/bin/bash

mytonctrl <<< "set stake 0"
mytonctrl <<< ve

sleep 20

BALANCE=$(mytonctrl <<< wl | grep validator_wallet_001 | awk '{print $3}' | cut -d '.' -f 1)
RANDOM_DEDUCT=$((RANDOM % 5 + 3))
STAKE=$(($BALANCE - $RANDOM_DEDUCT))
MIN_STAKE=250000

if [ $STAKE -lt $MIN_STAKE ]; then
	echo "ERROR: Lack of Amount"
	exit
fi

mytonctrl <<< "set stake $STAKE"
mytonctrl <<< ve
mytonctrl <<< "set stake 0"
