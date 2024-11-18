#!/bin/sh

# Copyright 2020 BlackYau <blackyau426@gmail.com>
# GNU General Public License v3.0

dir="/tmp/log/sdutlogin/" && mkdir -p ${dir}
logfile="${dir}sdutlogin.log"
pidpath=${dir}run.pid
count=0
enable=$(uci get sdutlogin.@login[0].enable)
[ $enable -eq 0 ] && echo "[$(date '+%Y-%m-%d %H:%M:%S')] 未启用,停止运行..." > ${logfile} && exit 0
interval=$(($(uci get sdutlogin.@login[0].interval)*60)) # 把时间换算成秒
alternative="$(uci get sdutlogin.@login[0].alternative)"
USER_ACCOUNT=$(uci get sdutlogin.@login[0].username)
USER_PASSWORD=$(uci get sdutlogin.@login[0].password)
USER_ACCOUNT2=$(uci get sdutlogin.@login[0].username2)
USER_PASSWORD2=$(uci get sdutlogin.@login[0].password2)
WLAN_USER_IP="$(ifconfig $IFCONFIG | grep 'inet addr:' | grep -oE '([0-9]{1,3}.){3}.[0-9]{1,3}' | head -n 1)"
response_file="/tmp/response.txt"


# 获取已连接设备数
function check(){
	local count=`cat /proc/net/arp|grep "0x2\|0x6"|awk '{print $1}'|grep -v "^169.254."|grep -v "^172.21."|grep -v "^$"|sort -u|wc -l $1`
	echo $count
}

# 控制log文件大小
function reducelog(){
	[ -f ${logfile} ] && local logrow=$(grep -c "" ${logfile}) || local logrow="0"
	[ $logrow -gt 500 ] && sed -i '1,100d' ${logfile} && echo "`date "+%Y-%m-%d %H:%M:%S"`  日志超出上限(500行)，删除前 100 条" >> ${logfile}
}

function login(){
	rm "$response_file"
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始拨号" >> ${logfile}
	echo "请求参数：" >> ${logfile}
    echo "用户名：$1" >> ${logfile}
    echo "密码：$2" >> ${logfile}
    echo "IP地址：$3" >> ${logfile}
	curl "http://172.16.253.121/quickauth.do?userid=$1&passwd=$2&wlanuserip=$3&wlanacname=NFV-BASE-SGYD2&wlanacIp=172.16.253.114&ssid=&vlan=1116&mac=c0%3A18%3A50%3Af9%3Ac1%3Ac5&version=0&portalpageid=2&timestamp=1730174830854&portaltype=0&hostname=HuaWei&bindCtrlId=&validateType=0&bindOperatorType=2&sendFttrNotice=0" \
	  -o "$response_file"
	response=$(cat "$response_file")
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] 服务器返回：$response" >> ${logfile}
}

# 如果在线返回真 关于返回值的问题:https://stackoverflow.com/a/43840545
function isonline(){
	local captiveReturnCode=`curl -s -I -m 10 -o /dev/null -s -w %{http_code} http://www.google.cn/generate_204`
	if [ "$captiveReturnCode" = "204" ]; then
		return
	fi
	false
}

function up(){
	if isonline; then
		echo "[$(date '+%Y-%m-%d %H:%M:%S')] 您已连接到网络!" >> ${logfile}
		sleep 1 && return
	fi

	# Login
	curl -m 5  https://www.baidu.com/ > baidu.com

	check_status=`curl -I -m 5 -s -w "%{http_code}\n" -o /dev/null www.baidu.com`
	echo $check_status >> ${logfile}

	if [[ $check_status != 200  ]]
	then
   	 echo "[$(date '+%Y-%m-%d %H:%M:%S')] Not signed in yet" >> ${logfile}
	 login $USER_ACCOUNT $USER_PASSWORD $WLAN_USER_IP
	fi

	if isonline; then
		ntpd -n -q -p ntp1.aliyun.com  # 登录成功后校准时间
		wait # 等待校准时间完毕
		echo "[$(date '+%Y-%m-%d %H:%M:%S')] 登录成功!" >> ${logfile} && sleep 2 && return
	else
		echo "[$(date '+%Y-%m-%d %H:%M:%S')] 登录失败" >> ${logfile}
		if [ "$alternative" = "1" ]; then
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 尝试使用备选账号登录..." >> ${logfile}
                    login $USER_ACCOUNT2 $USER_PASSWORD2 $WLAN_USER_IP
                    sleep 3
                    if isonline; then
                    	echo "[$(date '+%Y-%m-%d %H:%M:%S')] 备选账号认证成功！" >> ${logfile}
                    else
                        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 备选账号认证失败！" >> ${logfile}
                    fi
                else
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证失败，重试..." >> ${logfile}
                fi  

	fi
}


if [ -f ${pidpath} ]; then
    echo "终止之前的进程: $(cat $pidpath)"
    kill -9 $(cat $pidpath)>/dev/null 2>&1
    rm -rf $pidpath
    sleep 1
fi
echo $$ > $pidpath

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 进程已启动 pid:$(cat $pidpath)" > ${logfile}
