#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

CURRENT_UNIXTIME=$(date +%s)
CURRENT_HUMANTIME=$(date)
#COLORS
NO_COLOR='\e[0m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
CYAN='\e[36m'
GREEN_BACKGROUND='\e[42m'

CHECK_ELECTION_STATUS=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR active_election_id" | awk 'FNR == 6 {print $3}')

NODE_PUBKEY=$(mytonctrl <<< status fast | grep ADNL | grep local | grep validator | awk '{print $6}' | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")

if [ "$CHECK_ELECTION_STATUS" != 0 ];
then
  file="/tmp/mytoncore/"$CHECK_ELECTION_STATUS"_ElectionEntry.json"
    if [ ! -f "$file" ]
    then
    echo "NO JSON"
    JSON='0'
    else
    NODE_X_PUBKEY=$(cat /tmp/mytoncore/"$CHECK_ELECTION_STATUS"_ElectionEntry.json | grep '"validatorPubkey":' | awk '{print $2}' | tr -d '"')
    NODE_X_PUBKEY=$(printf "0x%s" "$NODE_X_PUBKEY" | tr [:upper:] [:lower:])
    fi
fi

echo ${site^h}
GETCONFIG15=$($LITE_CLIENT "getconfig 15")
GETCONFIG32=$($LITE_CLIENT "getconfig 32")
GETCONFIG34=$($LITE_CLIENT "getconfig 34")
GETCONFIG36=$($LITE_CLIENT "getconfig 36")

ELECTION_START_BEFORE=$(echo "${GETCONFIG15}" | awk 'FNR == 5 {print $5}' | tr -d 'elections_start_before:')
ELECTION_END_BEFORE=$(echo "${GETCONFIG15}" | awk 'FNR == 5 {print $6}' | tr -d 'elections_end_before:')


CHECK_TRANSITION_STATUS=$(echo "${GETCONFIG36}" | awk 'FNR == 5 {print $3}')

CHECK_ELECTION_SUBMISSION=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR participates_in ${NODE_X_PUBKEY}" | awk 'FNR == 6 {print $3}')
SUBMISSION_CHECK=10000

if [ $CHECK_ELECTION_SUBMISSION -le $SUBMISSION_CHECK ]
then
   CHECK_ELECTION_SUBMISSION=0
fi

#if [ "$JSON" == 0 ]; then
#. ~/node.operator.nt/configs/submission.sh
#fi

CHECK_VALIDATION_STATUS_NEW_ADNL_KEY=$(echo "${GETCONFIG34}" | grep $NODE_PUBKEY | awk '{print $4}' | tr -d ')' | tr -d 'adnl_addr:x')
CHECK_VALIDATION_STATUS_SECOND_NEW_ADNL_KEY=$(echo "${GETCONFIG34}" | grep $NODE_PUBKEY | awk '{print $4}' | tr -d ')' | tr -d 'adnl_addr:x')
CHECK_VALIDATION_STATUS_PREVIOUS_ADNL_KEY=$(echo "${GETCONFIG34}" | grep $NODE_PUBKEY | awk '{print $4}' | tr -d ')' | tr -d 'adnl_addr:x')
CHECK_VALIDATION_STATUS_SECOND_PREVIOUS_ADNL_KEY=$(echo "${GETCONFIG34}" | grep $NODE_PUBKEY | awk '{print $4}' | tr -d ')' | tr -d 'adnl_addr:x')
CHECK_VALIDATION_STATUS_PAST_ADNL_KEY=$(echo "${GETCONFIG32}" | grep $NODE_PUBKEY | awk '{print $4}' | tr -d ')' | tr -d 'adnl_addr:x')
CHECK_ELECTION_RESULT_NEW_ADNL_KEY=$(echo "${GETCONFIG36}" | grep $NODE_PUBKEY | awk '{print $4}' | tr -d ')' | tr -d 'adnl_addr:x')
CHECK_ELECTION_RESULT_SECOND_NEW_ADNL_KEY=$(echo "${GETCONFIG36}" | grep $NODE_PUBKEY | awk '{print $4}' | tr -d ')' | tr -d 'adnl_addr:x')

##1B - duration of validation cycle
CYCLE_DURATION=$(echo "${GETCONFIG15}" | awk 'FNR == 5 {print $4}' | tr -d 'validators_elected_for:')

##2 - get time variables from p34
###2A - get current validation
CURRENT_VALIDATION_SINCE_UNIXTIME=$(echo "${GETCONFIG34}" | grep time | awk '{print $2}' | tr -d 'utime_since:')
CURRENT_VALIDATION_UNTIL_UNIXTIME=$(echo "{$GETCONFIG34}" | grep time | awk '{print $3}' | tr -d 'utime_until:')

CURRENT_VALIDATION_SINCE_HUMANTIME=$(date -d @"$CURRENT_VALIDATION_SINCE_UNIXTIME")
CURRENT_VALIDATION_UNTIL_HUMANTIME=$(date -d @"$CURRENT_VALIDATION_UNTIL_UNIXTIME")

###2B - calculate previous validation cycle
PREVIOUS_VALIDATION_SINCE_UNIXTIME=$(expr $CURRENT_VALIDATION_SINCE_UNIXTIME - $CYCLE_DURATION)
PREVIOUS_VALIDATION_UNTIL_UNIXTIME=$(expr $CURRENT_VALIDATION_UNTIL_UNIXTIME - $CYCLE_DURATION)

PREVIOUS_VALIDATION_SINCE_HUMANTIME=$(date -d @"$PREVIOUS_VALIDATION_SINCE_UNIXTIME")
PREVIOUS_VALIDATION_UNTIL_HUMANTIME=$(date -d @"$PREVIOUS_VALIDATION_UNTIL_UNIXTIME")

###2C - calculate next validation cycle
NEXT_VALIDATION_SINCE_UNIXTIME=$(expr $CURRENT_VALIDATION_SINCE_UNIXTIME + $CYCLE_DURATION)
NEXT_VALIDATION_UNTIL_UNIXTIME=$(expr $CURRENT_VALIDATION_UNTIL_UNIXTIME + $CYCLE_DURATION)

NEXT_VALIDATION_SINCE_HUMANTIME=$(date -d @"$NEXT_VALIDATION_SINCE_UNIXTIME")
NEXT_VALIDATION_UNTIL_HUMANTIME=$(date -d @"$NEXT_VALIDATION_UNTIL_UNIXTIME")

##4 - calculate election cycles
###4A - calculate previous election start/end in unixtime and active-election-id
PREVIOUS_ACTIVE_ELECTION_ID=$(expr $CURRENT_VALIDATION_UNTIL_UNIXTIME - $CYCLE_DURATION)
PREVIOUS_ELECTION_SINCE_UNIXTIME=$(expr $CURRENT_VALIDATION_UNTIL_UNIXTIME - $ELECTION_START_BEFORE - $CYCLE_DURATION)
PREVIOUS_ELECTION_UNTIL_UNIXTIME=$(expr $CURRENT_VALIDATION_UNTIL_UNIXTIME - $ELECTION_END_BEFORE - $CYCLE_DURATION)

PREVIOUS_ELECTION_SINCE_HUMANTIME=$(date -d @"$PREVIOUS_ELECTION_SINCE_UNIXTIME")
PREVIOUS_ELECTION_UNTIL_HUMANTIME=$(date -d @"$PREVIOUS_ELECTION_UNTIL_UNIXTIME")

###4B - calculate upcoming election start/end and active-election-id
CURRENT_ACTIVE_ELECTION_ID=$CURRENT_VALIDATION_UNTIL_UNIXTIME
CURRENT_ELECTION_SINCE_UNIXTIME=$(expr $CURRENT_VALIDATION_UNTIL_UNIXTIME - $ELECTION_START_BEFORE)
CURRENT_ELECTION_UNTIL_UNIXTIME=$(expr $CURRENT_VALIDATION_UNTIL_UNIXTIME - $ELECTION_END_BEFORE)

CURRENT_ELECTION_SINCE_HUMANTIME=$(date -d @"$CURRENT_ELECTION_SINCE_UNIXTIME")
CURRENT_ELECTION_UNTIL_HUMANTIME=$(date -d @"$CURRENT_ELECTION_UNTIL_UNIXTIME")

###4C - calculate next election start/end in and active-election-id
NEXT_ACTIVE_ELECTION_ID=$(expr $CURRENT_VALIDATION_UNTIL_UNIXTIME + $CYCLE_DURATION)
NEXT_ELECTION_SINCE_UNIXTIME=$(expr $CURRENT_VALIDATION_UNTIL_UNIXTIME - $ELECTION_START_BEFORE + $CYCLE_DURATION)
NEXT_ELECTION_UNTIL_UNIXTIME=$(expr $CURRENT_VALIDATION_UNTIL_UNIXTIME - $ELECTION_END_BEFORE + $CYCLE_DURATION)

NEXT_ELECTION_SINCE_HUMANTIME=$(date -d @"$NEXT_ELECTION_SINCE_UNIXTIME")
NEXT_ELECTION_UNTIL_HUMANTIME=$(date -d @"$NEXT_ELECTION_UNTIL_UNIXTIME")

CURRENT_MY_WEIGHT=$(echo "${GETCONFIG34}" | grep $NODE_PUBKEY | awk '{print $3}' | tr -d 'weight:')
CURRENT_NETWORK_WEIGHT=$(echo "${GETCONFIG34}" | grep 'total_weight' | awk '{print $6}' | tr -d 'total_weight:')
CURRENT_MY_WEIGHT_PERCENTAGE=$(echo "scale=9; ${CURRENT_MY_WEIGHT:=1}/${CURRENT_NETWORK_WEIGHT:=1}" | bc -l)

CURRENT_MY_WEIGHT_TRANSITION=$(echo "${GETCONFIG34}" | grep $NODE_PUBKEY | awk '{print $3}' | tr -d 'weight:')
CURRENT_MY_WEIGHT_PERCENTAGE_TRANSITION=$(echo "scale=9; ${CURRENT_MY_WEIGHT_TRANSITION:=1}/${CURRENT_NETWORK_WEIGHT:=1}" | bc -l)

## calculate network weight and rewards for next round
NEXT_MY_WEIGHT=$(echo "${GETCONFIG36}" | grep $NODE_PUBKEY | awk '{print $3}' | tr -d 'weight:')
NEXT_NETWORK_WEIGHT=$(echo "${GETCONFIG36}" | grep 'total_weight' | awk '{print $6}' | tr -d 'total_weight:')
NEXT_MY_WEIGHT_PERCENTAGE=$(echo "scale=9; ${NEXT_MY_WEIGHT:=1}/${NEXT_NETWORK_WEIGHT:=1}" | bc -l)
NEXT_MY_STAKED_TOKENS=$(echo "scale=9; ${CHECK_ELECTION_SUBMISSION:=1}/1000000000" | bc -l)

PREVIOUS_TOTAL_STAKE=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR past_elections" | awk 'FNR == 6 {print $8}')
PREVIOUS_TOTAL_BONUS=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR past_elections" | awk 'FNR == 6 {print $9}')
PREVIOUS_INTEREST_RATE=$(echo "scale=9; ${PREVIOUS_TOTAL_BONUS:=1}/${PREVIOUS_TOTAL_STAKE:=1}" | bc -l)

EXPECTED_INTEREST_RATE="$PREVIOUS_INTEREST_RATE"
EXPECTED_MY_TOTAL_BONUS=$(echo "scale=9; ${PREVIOUS_INTEREST_RATE:=1}*${NEXT_MY_STAKED_TOKENS:=1}" | bc -l)

CURRENT_TOTAL_STAKE=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR past_elections" | awk 'FNR == 6 {print $16}')
CURRENT_TOTAL_BONUS=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR past_elections" | awk 'FNR == 6 {print $17}')

CURRENT_TOTAL_STAKE_TRANSITION=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR past_elections" | awk 'FNR == 6 {print $8}')
CURRENT_TOTAL_BONUS_TRANSITION=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR past_elections" | awk 'FNR == 6 {print $9}')

CURRENT_MY_STAKED_TOKENS=$(echo "scale=9; ${CURRENT_MY_WEIGHT_PERCENTAGE:=1}*${CURRENT_TOTAL_STAKE:=1}/1000000000" | bc -l)
CURRENT_MY_BONUS=$(echo "scale=9; ${CURRENT_MY_WEIGHT_PERCENTAGE:=1}*${CURRENT_TOTAL_BONUS:=1}/1000000000" | bc -l)

CURRENT_MY_BONUS_TRANSITION=$(echo "scale=9; ${CURRENT_MY_WEIGHT_PERCENTAGE_TRANSITION:=1}*${CURRENT_TOTAL_BONUS_TRANSITION:=1}/1000000000" | bc -l)

#EXPECTED_TOTAL_BONUS_PERCENTAGE=EXPECTED_TOTAL_BONUS/MYSTAKE
MY_COMPUTE_REWARD=$($LITE_CLIENT "runmethodfull $ELECTOR_ADDR compute_returned_stake $MY_XX_RAW_ADDRESS" | awk 'FNR == 5 {print $3}')

if [ $MY_COMPUTE_REWARD -le $SUBMISSION_CHECK ]
then
   MY_COMPUTE_REWARD=0
fi

MY_COMPUTE_REWARD_BALANCE=$(echo "scale=9; $MY_COMPUTE_REWARD"/1000000000 | bc -l)


