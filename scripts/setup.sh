#!/bin/bash

cd $HOME

# no Password
echo "$USER  ALL=(ALL:ALL)  NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# change timezone to KST
sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# package install
sudo apt update -y && sudo apt install git wget curl jq bc -y

# mytonctrl install
wget https://raw.githubusercontent.com/igroman787/mytonctrl/master/scripts/install.sh
sudo bash install.sh -m full
sudo chmod 777 /var/ton-work/db/config.json
mytonctrl <<< exit
rm $HOME/install.sh

cp $HOME/ton-scripts/configs/bash.config $HOME/.bashrc
source "$HOME/.bashrc"

crontab $HOME/ton-scripts/configs/cron.config
crontab -l

touch $HOME/serverno
