#!/bin/bash

OLD_DB=$(./ton-remain-disk.sh | tr -d 'G')
echo 'Start cleaning log file script'
echo 'clean' | sudo tee /var/ton-work/log*
sleep 5
NEW_DB=$(./ton-remain-disk.sh | tr -d 'G')
SECURED=$(($NEW_DB - $OLD_DB))
echo 'End cleaning log file script'
echo "Secured storage space as much as ${SECURED}G"
