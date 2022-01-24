#!/bin/bash

DEC_TO_HEX=$(echo "obase=16; ibase=10; $1" | bc)

echo $DEC_TO_HEX
