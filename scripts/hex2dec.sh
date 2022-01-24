#!/bin/bash

HEX_TO_DEC=$(echo "obase=10; ibase=16; $1" | bc | tr -d "\n" | sed 's/\\//g')

echo $HEX_TO_DEC
