#!/bin/bash

OLD_DB=$(./ton-remain-disk.sh | tr -d 'G')
echo 'clean' | sudo tee /var/ton-work/log*
echo "OLD SPACE: ${OLD_DB}G"
sleep 5
NEW_DB=$(./ton-remain-disk.sh | tr -d 'G')
SECURED=$(($NEW_DB - $OLD_DB))
echo "NEW SPACE: ${NEW_DB}G"
echo "Secured storage space as much as ${SECURED}G"
