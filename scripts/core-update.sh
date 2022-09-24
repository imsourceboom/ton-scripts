#!/bin/bash

MYTONCORE="/usr/src/mytonctrl/mytoncore.py"
TMP_CORE="/tmp/mytoncore.py"

sudo cp $MYTONCORE /tmp
sudo chown $USER:$USER $TMP_CORE

SP_TO_DEDUCT=$(cat $TMP_CORE | grep 'sp = stakePercent' | sed -e "s/sp = stakePercent \/ 100/deduct = random.randint(4, 8)/")

sed -i "/sp = stakePercent \/ 100/a\ $SP_TO_DEDUCT" $TMP_CORE
sed -i "/stake = int(account.balance\*sp/a\                                stake = account.balance - deduct" $TMP_CORE
sed -i "s/stake = int(account.balance\*sp\/2)/#stake = int(account.balance\*sp\/2)/" $TMP_CORE
sed -i "s/stake = int(account.balance\*sp)/#stake = int(account.balance\*sp)/" $TMP_CORE

cat $TMP_CORE | sudo tee $MYTONCORE >/dev/null

cat $MYTONCORE | grep 'deduct'
sudo systemctl restart mytoncore.service
systemctl status mytoncore.service | grep 'Active'
mytonctrl <<< "wl" | grep 'validator_wallet_001'
