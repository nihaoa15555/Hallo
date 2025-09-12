#!/bin/sh

# 配置参数（仅读取一次基础配置）
USER_ACCOUNT="$(uci get autoweblogin.config.user_account)"
USER_PASSWORD="$(uci get autoweblogin.config.user_password)"
LOG_FILE="/tmp/log/autoweblogin.log"
RESPONSE_FILE="/tmp/response.txt"
PING_TARGET="223.5.5.5"  # 目标检测IP
CHECK_INTERVAL=3         # 检查间隔（秒）

# 日志函数：统一处理日志写入和行数控制
log() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE"
    
    # 控制日志行数（超过200行时保留最新100行，避免完全覆盖历史）
    local log_line_count=$(wc -l < "$LOG_FILE")
    if [ "$log_line_count" -gt 200 ]; then
        tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp"
        mv "$LOG_FILE.tmp" "$LOG_FILE"
        log "日志行数超过200，已保留最新100行"
    fi
}

# 网络检测函数：返回0表示连接，1表示断开
is_connected() {
    ping -c 1 -W 2 "$PING_TARGET" >/dev/null 2>&1
    return $?
}

# 认证函数：动态获取实时参数并发起请求
portal() {
    # 动态获取可能变化的参数（IP、MAC、时间戳）
    local wlan_user_ip=$(ifconfig eth1 | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)
    local mac=$(ifconfig eth1 | grep -oE '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}')
    local seconds=$(date -u +%s)
    local nanoseconds=$(date -u +%N)
    local milliseconds=$((seconds * 1000 + nanoseconds / 1000000))

    # 日志脱敏显示账号密码
    log "请求参数："
    log "账号：${USER_ACCOUNT:0:6}***"
    log "密码：${USER_PASSWORD:0:6}***"

    # 发起认证请求（直接覆盖响应文件，无需提前删除）
    curl -s "http://172.16.253.121/quickauth.do?userid=$USER_ACCOUNT&passwd=$USER_PASSWORD&wlanuserip=$wlan_user_ip&wlanacname=NFV-BASE-SGYD2&wlanacIp=172.16.253.114&ssid=&vlan=1116&mac=$mac&version=0&portalpageid=2&timestamp=$milliseconds&portaltype=0&hostname=HuaWei&bindCtrlId=&validateType=0&bindOperatorType=2&sendFttrNotice=0" -o "$RESPONSE_FILE"

    # 解析响应信息
    local response=$(cat "$RESPONSE_FILE")
    local message=$(echo "$response" | grep -o '"message":"[^"]*"' | sed -e 's/"message":"//' -e 's/"//')
    log "服务器返回：$message"
}

# 主逻辑：简化循环结构，减少嵌套
log "脚本开始运行"
while true; do
    if is_connected; then
        # 网络正常，间隔检查
        sleep "$CHECK_INTERVAL"
    else
        # 网络异常，二次确认避免误判
        log "网络异常，进行二次检测..."
        sleep 1
        if ! is_connected; then
            log "网络确实异常，发起认证请求..."
            portal  # 执行认证
            
            # 认证后检查结果
            if is_connected; then
                log "认证成功！"
            else
                log "认证失败，将重试..."
            fi
        fi
    fi
done
