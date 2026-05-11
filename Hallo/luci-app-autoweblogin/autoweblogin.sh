#!/bin/sh

USER_ACCOUNT="$(uci get autoweblogin.config.user_account)"
USER_PASSWORD="$(uci get autoweblogin.config.user_password)"
WLAN_USER_IP="$(ifconfig eth1 | grep 'inet addr:' | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)"
MAC="$(ifconfig eth1 | grep -oE '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}')"
Seconds=$(date -u +%s)
Nanoseconds=$(date -u +%N)
Milliseconds=$((Seconds * 1000 + Nanoseconds / 1000000))
response_file="/tmp/response.txt"


portal() {
    rm "$response_file"
	curl "http://172.16.253.121/quickauth.do?userid=$1&passwd=$2&wlanuserip=$3&wlanacname=NFV-BASE-SGYD2&wlanacIp=172.16.253.114&ssid=&vlan=1116&mac=$4&version=0&portalpageid=2&timestamp=$5&portaltype=0&hostname=HuaWei&bindCtrlId=&validateType=0&bindOperatorType=2&sendFttrNotice=0" \
	  -o "$response_file"
    response=$(cat "$response_file")
	message=$(echo "$response" | grep -o '"message":"[^"]*"' | sed -e 's/"message":"//' -e 's/"//')
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 服务器返回 $message" >> "$log_file"
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
        portal "$USER_ACCOUNT" "$USER_PASSWORD" "$WLAN_USER_IP" "$MAC" "$Milliseconds"
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
