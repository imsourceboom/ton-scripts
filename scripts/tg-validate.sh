#!/bin/bash

source "$HOME/ton-scripts/scripts/env.sh"

VALIDATE=$($SCRIPTS_DIR/ton-validate-state.sh)

if [ $VALIDATE != "ACTIVE" ]; then
	MESSAGE="⛓ Not Validation"
	$TG_SEND_ALARM "validate" "$MESSAGE" 2>&1 > /dev/null
fi


