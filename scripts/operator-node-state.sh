#!/bin/bash

source "$HOME/ton-scripts/scripts/operator-env.sh"

#CHECK VALIDATION STATUS
## if NO election and NO transition status
if [ "$CHECK_ELECTION_STATUS" == 0 ] && [ "$CHECK_TRANSITION_STATUS" == "(null)" ];
then
        if [ "$CHECK_VALIDATION_STATUS_NEW_ADNL_KEY" == "$NODE_PUBKEY" ] || [ "$CHECK_VALIDATION_STATUS_SECOND_NEW_ADNL_KEY" == "$NODE_PUBKEY" ];
        then
                printf "${CYAN}-------------CURRENTLY VALIDATING-------------\n"
                printf "Validation Until: "
                printf "$CURRENT_VALIDATION_UNTIL_HUMANTIME\n"
                printf "Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME\n"
                printf "Rewards Earned: "
                printf "$CURRENT_MY_BONUS\n"
                printf "Recoverable: "
                printf "$NEXT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
                printf "${YELLOW}Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
        else
                printf "${RED}-------------CURRENTLY NOT VALIDATING-------------\n"
                printf "This error could've been caused by unmatching ADNL record${NO_COLOR}\n"
                printf "${YELLOW}Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
        fi
fi

## if YES election
if [ "$CHECK_ELECTION_STATUS" != 0 ];
then
        ## if YES election submission
        if [ "CHECK_ELECTION_SUBMISSION" != 0 ] && [ "$CHECK_VALIDATION_STATUS_PREVIOUS_ADNL_KEY" == "$NODE_PUBKEY" ] || [ "$CHECK_VALIDATION_STATUS_SECOND_PREVIOUS_ADNL_KEY" == "$NODE_PUBKEY" ];
        then
                printf "${CYAN}-------------CURRENTLY VALIDATING-------------\n"
                printf "Validation Until: "
                printf "$CURRENT_VALIDATION_UNTIL_HUMANTIME\n"
                printf "Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME\n"
                printf "Rewards Earned: "
                printf "$CURRENT_MY_BONUS_TRANSITION\n"
                printf "Recoverable: "
                printf "$NEXT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
                printf "${YELLOW}Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"

        ## if NO election submission
        elif [ "$CHECK_ELECTION_SUBMISSION" == 0 ] && [ "$CHECK_VALIDATION_STATUS_NEW_ADNL_KEY" == "$NODE_PUBKEY" ] || [ "$CHECK_VALIDATION_STATUS_SECOND_NEW_ADNL_KEY" == "$NODE_PUBKEY" ];
        then
                printf "${CYAN}-------------CURRENTLY VALIDATING-------------\n"
                printf "Validation Until: "
                printf "$CURRENT_VALIDATION_UNTIL_HUMANTIME\n"
                printf "Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME\n"
                printf "Rewards Earned: "
                printf "$CURRENT_MY_BONUS_TRANSITION\n"
                printf "Recoverable: "
                printf "$NEXT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
                printf "${YELLOW}Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
        else
                printf "${RED}-------------CURRENTLY NOT VALIDATING-------------\n"
                printf "This error could've been caused by unmatching ADNL record${NO_COLOR}\n"
                printf "${YELLOW}Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
        fi
fi

## if YES transition status
if [ "$CHECK_TRANSITION_STATUS" != "(null)" ];
then
        if [ "$CHECK_VALIDATION_STATUS_PREVIOUS_ADNL_KEY" == "$NODE_PUBKEY" ];
        then
                printf "${CYAN}-------------CURRENTLY VALIDATING-------------\n"
                printf "Validation Until: "
                printf "$CURRENT_VALIDATION_UNTIL_HUMANTIME\n"
                printf "Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME\n"
                printf "Rewards Earned: "
                printf "$CURRENT_MY_BONUS_TRANSITION\n"
                printf "Recoverable: "
                printf "$NEXT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
                printf "${YELLOW}Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
        else
                printf "${RED}-------------CURRENTLY NOT VALIDATING-------------\n"
                printf "This error could've been caused by unmatching ADNL record${NO_COLOR}\n"
                printf "${YELLOW}Next Election: "
                printf "$CURRENT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
        fi
fi

#CHECK ELECTION STATUS
if [ "$CHECK_ELECTION_STATUS" != 0 ];
then
        if [ "$CHECK_ELECTION_SUBMISSION" != 0 ];
        then
                printf "${GREEN}---------------SUBMISSION CONFIRMED---------------\n"
                printf "Election ID: "
                printf "$CURRENT_ACTIVE_ELECTION_ID\n"
                printf "Staked Tokens: "
                printf "$NEXT_MY_STAKED_TOKENS\n"
                printf "Expected Reward: "
                printf "$EXPECTED_MY_TOTAL_BONUS\n"
                printf "Expected Interest Rate: "
                printf "$EXPECTED_INTEREST_RATE\n"
                printf "Recoverable: "
                printf "$NEXT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
                printf "${YELLOW}Election Result: "
                printf "$CURRENT_ELECTION_UNTIL_HUMANTIME${NO_COLOR}\n"
        elif [ "$MY_COMPUTE_REWARD" != 0 ];
        then
                printf "${RED}----------------RECOVER STAKES-----------------${NO_COLOR}\n"
                printf "${YELLOW}Available For Recovery${NO_COLOR}: "
                printf "${GREEN}$MY_COMPUTE_REWARD_BALANCE${NO_COLOR}\n"
                printf "Election Until: "
                printf "$CURRENT_ELECTION_UNTIL_HUMANTIME${NO_COLOR}\n"
        elif [ "$CHECK_ELECTION_SUBMISSION" == 0 ] && [ "$MY_COMPUTE_REWARD" == 0 ];
        then
                printf "${RED}--------------SUBMISSION UNCONFIRMED--------------\n"
                printf "WARNING: NO STAKES FOUND\n"
                printf "Election ID: "
                printf "$CURRENT_ACTIVE_ELECTION_ID\n"
                printf "${YELLOW}Election Until: "
                printf "$CURRENT_ELECTION_UNTIL_HUMANTIME${NO_COLOR}\n"
        fi
fi
if [ "$CHECK_ELECTION_STATUS" == 0 ] && [ "$CHECK_TRANSITION_STATUS" != "(null)" ];
then
        if [ "$CHECK_ELECTION_RESULT_NEW_ADNL_KEY" == "$NODE_PUBKEY" ] || [ "$CHECK_ELECTION_RESULT_SECOND_NEW_ADNL_KEY" == "$NODE_PUBKEY" ];
        then
                printf "${GREEN}----------------ELECTED VALIDATOR----------------\n"
                printf "Election Result: ${GREEN_BACKGROUND}${BLUE}SUCCESS${NO_COLOR}\n"
                printf "${GREEN}Validation Begins: "
                printf "$NEXT_VALIDATION_SINCE_HUMANTIME${NO_COLOR}\n"
                printf "${YELLOW}Next Election: "
                printf "$NEXT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
        else
                printf "${RED}----------------ELECTION FAILED---------------${NO_COLOR}\n"
                printf "${YELLOW}Stakes Held Until"
                printf "$CURRENT_ELECTION_UNTIL_HUMANTIME\n"
                printf "${YELLOW}Next Election: "
                printf "$NEXT_ELECTION_SINCE_HUMANTIME${NO_COLOR}\n"
        fi
fi
