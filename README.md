# TON Node Management Scripts

- user 계정 생성 후 sudo 권한 부여 (example: username)

```
sudo adduser username
sudo usermod -aG sudo username
```

- ssh 셋팅

```
sudo cp -r $HOME/.ssh /home/username
sudo chown -R username:username /home/username/.ssh
```

---

> 생성한 계정으로 접속

1. node 셋팅

```
cd $HOME/ton-scripts/scripts
./setup.sh
source $HOME/.bashrc
```

2. 첫 Election은 수동으로 참여

```
mytonctrl <<< "set stake [amount]"
mytonctrl <<< ve

# 약 20초 후 일렉션 참여 확인
sleep 20
state
```

- [amount]: ton 수량으로 기입
- 첫 election 참여 후 crontab의 operator-stake.sh 라인 주석 제거

3. serverno file에 서버 별칭 기입

```
echo "your server alias" > $HOME/serverno
```

4. telegram alarm 설정

- $HOME/ton-scripts/scripts/telegram-api.json 파일에 bot token 과 chat id 기입
- crontab의 tg-index.sh 라인 주석 제거

5. node 운영 중 Disk 관련 Alarm이 올 경우

```
cd $HOME/ton-scripts/scripts
./operator-clean-disk.sh
```
