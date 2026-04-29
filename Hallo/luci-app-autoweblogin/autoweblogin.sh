#!/bin/sh

USER_PASSWORD="$(uci get autoweblogin.config.user_password)"
USER_ID2="$USER_PASSWORD@139.gd"
USER_PASSWORD2="${USER_PASSWORD: -6}"
response_file="/tmp/response.txt"


portal2() {
	rm "$response_file"
    echo "账号：${1:0:6}***" >> "$log_file"
	curl -d "wname=$1&wpwd=$2&login=登录" http://172.16.253.114/cgi-bin/wlogin.cgi
}

log_file="/tmp/log/autoweblogin.log"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始运行" >> "$log_file"

while true; do
    while true; do
        if ping -c 1 119.29.29.29 >/dev/null; then
            sleep 2
        else
            log_line_count=$(wc -l < "$log_file")
            if [ "$log_line_count" -gt 200 ]; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] 日志达到上限，已清除" > "$log_file"
            fi
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络异常" >> "$log_file"
            sleep 2
            break
        fi
    done

    while true; do
        if ping -c 1 223.5.5.5 >/dev/null; then
            break
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络异常，发起认证" >> "$log_file"
            portal2 "$USER_ID2" "$USER_PASSWORD2"
			sleep 2
			
            if ! ping -c 1 119.29.29.29 >/dev/null; then 
				echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络异常" >> "$log_file"
                portal2 "$USER_ID2" "$USER_PASSWORD2"
            fi
            sleep 2
			
            if ping -c 1 223.5.5.5 >/dev/null; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证成功" >> "$log_file"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证失败，正在重试" >> "$log_file"
            fi
        fi
    done
done
