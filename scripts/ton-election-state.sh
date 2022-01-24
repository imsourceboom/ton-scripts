#!/bin/bash

. env.sh

ELECTIONS_ID=$(ton-election-id.sh)
if [ $ELECTIONS_ID = "-1" ]; then
	echo "ERROR: Can't get election date"
	exit
fi

if [ $ELECTIONS_ID = "0" ]; then
        echo "STOPPED"
	exit
fi

if (( $ELECTIONS_ID > 0 )); then
	echo "ACTIVE"
	exit
fi

echo "ERROR: unknown election id $ELECTIONS_ID"
