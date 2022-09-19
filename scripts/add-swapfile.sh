#!/bin/bash

# Make Swapfile
sudo fallocate -l 30G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && sudo swapon --show
# Maintain swapfile memory even after reboot
echo '/swapfile   none    swap    sw    0   0' | sudo tee -a /etc/fstab
