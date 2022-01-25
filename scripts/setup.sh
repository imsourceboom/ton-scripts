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
sudo chmod 755 /var/ton-work/db/config.json
#sudo chmod 777 $HOME/.local/share/mytonctrl
mytonctrl <<< "set stake 0"
rm $HOME/install.sh

# .bashrc copy
cp $HOME/ton-scripts/configs/bash.config $HOME/.bashrc

# crontab copy
crontab $HOME/ton-scripts/configs/cron.config
crontab -l

# create server name file
touch $HOME/serverno

echo "--------------------"
echo "Please run command"
echo "source $HOME/.bashrc"
