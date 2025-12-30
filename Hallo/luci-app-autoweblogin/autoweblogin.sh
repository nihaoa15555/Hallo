#!/bin/sh

USER_ACCOUNT="$(uci get autoweblogin.config.user_account)"
USER_PASSWORD="$(uci get autoweblogin.config.user_password)"
WLAN_USER_IP="$(ifconfig eth1 | grep 'inet addr:' | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)"
MAC="$(ifconfig eth1 | grep -oE '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}')"
Seconds=$(date -u +%s)
Nanoseconds=$(date -u +%N)
Milliseconds=$((Seconds * 1000 + Nanoseconds / 1000000))
USER_ID2="$USER_PASSWORD@139.gd"
USER_PASSWORD2="${USER_PASSWORD: -6}"


response_file="/tmp/response.txt"

portal1() {
    rm "$response_file"
    echo "请求参数：" >> "$log_file"
    echo "账号：${1:0:6}***" >> "$log_file"
    echo "密码：${2:0:6}***" >> "$log_file"
	curl "http://172.16.253.121/quickauth.do?userid=$1&passwd=$2&wlanuserip=$3&wlanacname=NFV-BASE-SGYD2&wlanacIp=172.16.253.114&ssid=&vlan=1116&mac=$4&version=0&portalpageid=2&timestamp=$5&portaltype=0&hostname=HuaWei&bindCtrlId=&validateType=0&bindOperatorType=2&sendFttrNotice=0" \
	  -o "$response_file"
    response=$(cat "$response_file")
	message=$(echo "$response" | grep -o '"message":"[^"]*"' | sed -e 's/"message":"//' -e 's/"//')
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 服务器返回：$message" >> "$log_file"

}

portal2() {
	curl -d "wname=${USER_ID2}&wpwd=${USER_PASSWORD2}&login=登录" http://172.16.253.114/cgi-bin/wlogin.cgi
}



log_file="/tmp/log/autoweblogin.log"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始运行" >> "$log_file"

while true; do
    # 第一层：网络连通性监测
    while true; do
        # 修复ping：重定向标准输出和错误
        if ping -c 1 223.5.5.5 >/dev/null 2>&1; then
            sleep 3
        else
            # 日志轮转（替代直接覆盖）
            rotate_log
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络异常，进行二次网络监测，避免误测" >> "$log_file"
            sleep 3
            break
        fi
    done

    # 第二层：二次验证+自动认证
    while true; do
        if ping -c 1 223.5.5.5 >/dev/null 2>&1; then
            break
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络异常，发起portal1认证请求..." >> "$log_file"
            
            # 获取实时毫秒时间戳
            Milliseconds=$(get_milliseconds)
            # 调用portal1（变量加双引号）
            portal1 "$USER_ACCOUNT" "$USER_PASSWORD" "$WLAN_USER_IP" "$MAC" "$Milliseconds"

            # 修复if语句：添加闭合fi，规范缩进
            if ping -c 1 223.5.5.5 >/dev/null 2>&1; then 
                portal2
                sleep 3
            fi

            # 再次检测网络
            if ping -c 1 223.5.5.5 >/dev/null 2>&1; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证成功！！" >> "$log_file"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证失败，即将重试..." >> "$log_file"
            fi
            sleep 3  # 增加重试间隔，避免高频请求
        fi
    done
done

