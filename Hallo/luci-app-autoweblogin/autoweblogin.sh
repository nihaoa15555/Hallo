#!/bin/sh

USER_PASSWORD="$(uci get autoweblogin.config.user_password)"
USER_ID2="$USER_PASSWORD@139.gd"
USER_PASSWORD2="${USER_PASSWORD: -6}"
response_file="/tmp/response.txt"


portal() {
	rm "$response_file"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 账号：${1:0:6}***" >> "$log_file"
	curl -d "wname=$1&wpwd=$2&login=登录" http://172.16.253.114/cgi-bin/wlogin.cgi
}

log_file="/tmp/log/autoweblogin.log"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始运行" >> "$log_file"

while true; do
    if ping -c 1 -W 2 223.5.5.5 >/dev/null 2>&1; then
        sleep 2
        continue
    fi

    log_line_count=$(wc -l < "$log_file" 2>/dev/null || echo 0)
    if [ "$log_line_count" -gt 200 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 日志已满，已清空" > "$log_file"
    fi
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络异常" >> "$log_file"
    sleep 2

    while true; do
        portal "$USER_ID2" "$USER_PASSWORD2"
        sleep 2

        if ping -c 1 -W 2 223.5.5.5 >/dev/null 2>&1; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证成功" >> "$log_file"
            break
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证失败" >> "$log_file"
            sleep 2
        fi
    done
done
