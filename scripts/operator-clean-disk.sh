#!/bin/bash

sudo systemctl stop validator

echo "DELETING LOG FILES..."
cd /var/ton-work/db && sudo find -name 'LOG.old*' -exec rm {} +

sudo systemctl start validator
echo "DONE!"
