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

ton-scripts/scripts

1. mytonctrl 포함 node 셋팅

```
setup.sh
```

2. alarm 설정

- telegram-api.json 파일에 bot token 과 chat id 기입
- crontab의 tg-index.sh 라인 주석 제거
