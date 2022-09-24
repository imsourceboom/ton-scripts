#!/bin/bash

MYTONCORE="/usr/src/mytonctrl/mytoncore.py"

sed -i "/sp = stakePercent \/ 100/a\ \t\t\tdeduct = random.randint(4, 8)" $MYTONCORE
sed -i "/stake = int(account.balance\*sp/a\ \t\t\t\tstake = account.balance - deduct" $MYTONCORE
sed -i "s/stake = int(account.balance\*sp\/2)/#stake = int(account.balance\*sp\/2)/" $MYTONCORE
sed -i "s/stake = int(account.balance\*sp)/#stake = int(account.balance\*sp)/" $MYTONCORE

cat $MYTONCORE | grep 'deduct'
sudo systemctl restart mytoncore.service
systemctl status mytoncore.service | grep 'Active'
mytonctrl <<< "wl" | grep 'validator_wallet_001'
