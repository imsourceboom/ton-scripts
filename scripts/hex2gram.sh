#!/bin/bash

CONVERT=1000000000
GRAM_TOKEN=$(echo $1 $CONVERT | awk '{printf "%.9f\n", $1 / $2}')

echo $GRAM_TOKEN
