#!/bin/bash

TOKEN=$(cat telegram-api.json | jq -r ".telegram_bot_token")
VALIDATE_CHAT_ID=$(cat telegram-api.json | jq -r ".telegram_validate_chat_id")
ELECTION_CHAT_ID=$(cat telegram-api.json | jq -r ".telegram_election_chat_id")
BALANCE_CHAT_ID=$(cat telegram-api.json | jq -r ".telegram_balance_chat_id")

CHAT_ID="$1"
SERVER=$(cat $HOME/serverno)
MESSAGE="$2"

if [ $CHAT_ID == "validate" ]; then
	CHAT_ID=$VALIDATE_CHAT_ID
fi

if [ $CHAT_ID == "election" ]; then
	CHAT_ID=$ELECTION_CHAT_ID
fi

if [ $CHAT_ID == "balance" ]; then
	CHAT_ID=$BALANCE_CHAT_ID
fi

curl -s \
	--data parse_mode=HTML \
        --data chat_id=${CHAT_ID} \
        --data text="<b>${SERVER}</b>%0A${MESSAGE}" \
        --request POST https://api.telegram.org/bot$TOKEN/sendMessage
