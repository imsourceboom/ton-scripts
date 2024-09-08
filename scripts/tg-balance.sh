#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

LIMIT=100
BALANCE=$(mytonctrl <<< "wl" | grep "validator_wallet_001" | awk '{print $3}' | cut -d '.' -f 1)

if [ $BALANCE -lt $LIMIT ]; then
        MESSAGE="Insufficient Balance ! ${BALANCE} 💎"
        $TG_SEND_ALARM "unique" "$MESSAGE" 2>&1 > /dev/null
fi
