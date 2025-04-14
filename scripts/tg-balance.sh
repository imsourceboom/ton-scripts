#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

LIMIT=50
BALANCE=$(mytonctrl <<< "wl" | grep "validator_wallet_001" | awk '{print $3}' | cut -d '.' -f 1)

if [ $BALANCE -lt $LIMIT ]; then
        MESSAGE="💰 Insufficient Balance%0AValidator Balance: ${BALANCE} TON"
        $TG_SEND_ALARM "balance" "$MESSAGE" 2>&1 > /dev/null
fi
