#!/bin/bash

. env.sh

ELECTIONS_ID=$(ton-election-id.sh)
if [ $ELECTIONS_ID = "-1" ]; then
	echo "ERROR: Can't get election date"
     	exit
fi

if [ $ELECTIONS_ID = "0" ]; then
       	echo "-1"
    	exit
fi

GETCONFIG_15=$($LITE_CLIENT "getconfig 15")
ELECTIONS_END_BEFORE=$(echo $GETCONFIG_15 | awk -F 'elections_end_before:' '{print $2}' | cut -d ' ' -f 1)

echo $(($ELECTIONS_ID - $ELECTIONS_END_BEFORE))
