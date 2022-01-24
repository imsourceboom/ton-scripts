#!/bin/bash

TOKEN=$(cat telegram-api.json | jq -r ".telegram_bot_token")
NORMAL_CHAT_ID=$(cat telegram-api.json | jq -r ".telegram_normal_chat_id")
UNIQUE_CHAT_ID=$(cat telegram-api.json | jq -r ".telegram_unique_chat_id")

CHAT_ID="$1"
SERVER=$(cat $HOME/serverno)
MESSAGE="$2"

if [ $CHAT_ID == "normal" ]; then
	CHAT_ID=$NORMAL_CHAT_ID
fi

if [ $CHAT_ID == "unique" ]; then
	CHAT_ID=$UNIQUE_CHAT_ID
fi

curl -s \
	--data parse_mode=HTML \
        --data chat_id=${CHAT_ID} \
        --data text="<b>${SERVER}</b>%0A${MESSAGE}" \
        --request POST https://api.telegram.org/bot$TOKEN/sendMessage
