#!/bin/bash

. env.sh

DB=$(df -h / | awk 'FNR == 2 {print $4}')

echo $DB
