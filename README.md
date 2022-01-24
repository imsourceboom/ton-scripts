# TON Node Management Scripts

- user 계정 생성 후 sudo 권한 부여
- user 계정 접속 후 ssh 셋팅

---

ton-scripts/scripts

1. mytonctrl 포함 node 셋팅

```
setup.sh
```

2. alarm 설정

- telegram-api.json 파일에 bot token 과 chat id 기입
- crontab의 tg-index.sh 라인 주석 제거
