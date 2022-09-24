#!/bin/bash

MYTONCORE="/usr/src/mytonctrl/mytoncore.py"
TMP_CORE="/tmp/mytoncore.py"

sudo cp $MYTONCORE /tmp

sed -i "/sp = stakePercent \/ 100/a\ \t\t\tdeduct = random.randint(4, 8)" $TMP_CORE
sed -i "/stake = int(account.balance\*sp/a\ \t\t\t\tstake = account.balance - deduct" $TMP_CORE
sed -i "s/stake = int(account.balance\*sp\/2)/#stake = int(account.balance\*sp\/2)/" $TMP_CORE
sed -i "s/stake = int(account.balance\*sp)/#stake = int(account.balance\*sp)/" $TMP_CORE

cat $TMP_CORE > $MYTONCORE

cat $MYTONCORE | grep 'deduct'
sudo systemctl restart mytoncore.service
systemctl status mytoncore.service | grep 'Active'
mytonctrl <<< "wl" | grep 'validator_wallet_001'
