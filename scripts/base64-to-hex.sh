#!/bin/bash

BASE64_TO_HEX=$(echo $1 | base64 -d | od -t x1 -An | tr -d ' \n' | tr [:lower:] [:upper:])

echo $BASE64_TO_HEX
