#!/bin/bash

sudo sed -i "s|ExecStart = .*|ExecStart = /usr/bin/ton/validator-engine/validator-engine --threads 15 --daemonize --global-config /usr/bin/ton/global.config.json --db /var/ton-work/db/ --logname /var/ton-work/log --state-ttl 604800 --archive-ttl 1209600 --verbosity 1|g" /etc/systemd/system/validator.service
sudo systemctl daemon-reload
sudo systemctl restart validator.service
