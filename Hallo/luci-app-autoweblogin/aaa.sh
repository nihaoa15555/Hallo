#!/bin/sh

MODE="$(uci get autoweblogin.config.mode)"
USERID="$(uci get autoweblogin.config.user_account)"
PASSWD="$(uci get autoweblogin.config.user_password)"
TIME="$(uci get autoweblogin.config.time)"
WLANIP="$(ifconfig eth1 | grep 'inet addr:' | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)"
MAC="$(ifconfig eth1 | grep -oE '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}')"   
Seconds=$(date -u +%s)
Nanoseconds=$(date -u +%N)
Milliseconds=$((Seconds * 1000 + Nanoseconds / 1000000))
response_file="/tmp/response.txt"

MODE1() {
    rm "$response_file"
    echo "请求参数-账号：$USERID  密码：$PASSWD  IP地址：$WLANIP  MAC地址：$MAC" >> "$log_file"
	curl "http://172.16.253.121/quickauth.do?userid=$USERID&passwd=$PASSWD&wlanuserip=$WLANIP&wlanacname=NFV-BASE-SGYD2&wlanacIp=172.16.253.114&ssid=&vlan=1116&mac=$MAC&version=0&portalpageid=2&timestamp=$Milliseconds&portaltype=0&hostname=HuaWei&bindCtrlId=&validateType=0&bindOperatorType=2&sendFttrNotice=0" \
	  -o "$response_file"
    response=$(cat "$response_file")
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 服务器返回：$response" >> "$log_file"
}

MODE2() {
    rm "$response_file"
    echo "请求参数-账号：$USERID  密码：$PASSWD  IP地址：$WLANIP  MAC地址：$MAC" >> "$log_file"
	curl "http://172.16.13.10:6060/quickauth.do?userid=$USERID&passwd=$PASSWD&wlanuserip=$WLANIP&wlanacname=NFV-BASE&wlanacIp=172.16.13.11&ssid=&vlan=24012633&mac=$MAC&version=0&portalpageid=2&validateCode=&timestamp=$Milliseconds&portaltype=0&hostname=HuaWei&bindCtrlId=&validateType=0&bindOperatorType=2" \
	  -o "$response_file"
    response=$(cat "$response_file")
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 服务器返回：$response" >> "$log_file"
}

MODE3() {
    rm "$response_file"
    echo "请求参数-账号：$USERID  密码：$PASSWD  IP地址：$WLANIP  MAC地址：$MAC" >> "$log_file"
	curl "xxxxx" \
	  -o "$response_file"
    response=$(cat "$response_file")
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 服务器返回：$response" >> "$log_file"
}




log_file="/tmp/log/autoweblogin.log"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始运行" >> "$log_file"

while true; do
    while true; do
        if ping -c 1 223.5.5.5 >/dev/null; then
            sleep $TIME
        else
            log_line_count=$(wc -l < "$log_file")
            if [ "$log_line_count" -gt 200 ]; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] 日志达到上限200行，已覆盖" > "$log_file"
            fi
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络异常，进行二次网络监测，避免误测" >> "$log_file"
            sleep 3
            break
        fi
    done

    while true; do
        if ping -c 1 223.5.5.5 >/dev/null; then
            break
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络异常，发起认证请求..." >> "$log_file"

            case "$MODE" in
                MODE1)
                    MODE1
                    ;;
                MODE2)
                    MODE2
                    ;;
                MODE3)
                    MODE3
                    ;;
            esac
            
            sleep 3

            if ping -c 1 223.5.5.5 >/dev/null; then
                
                echo "认证成功！！" >> "$log_file"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证失败，重试..." >> "$log_file"
 
            fi
        fi
    done
done
