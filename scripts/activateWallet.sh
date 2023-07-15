#!/bin/bash

WALLET=$1

function ACTIVATE_WALLET () {
	mytonctrl <<< "aw $1"
}

ACTIVATE_WALLET $WALLET
