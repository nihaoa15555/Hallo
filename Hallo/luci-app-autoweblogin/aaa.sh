#!/bin/sh

# --------------------------
# 1. 配置参数（集中管理，便于修改）
# --------------------------
# 网络检测配置
PING_TARGET="223.5.5.5"          # 检测目标（阿里云DNS）
PING_INTERVAL=4                   # 网络正常时检测间隔（秒）
RECHECK_INTERVAL=3                # 异常二次检测/认证后等待间隔（秒）
# 日志配置
LOG_FILE="/tmp/log/autoweblogin.log"
LOG_MAX_LINES=200                 # 日志最大行数
LOG_RESERVE_LINES=10              # 日志满时保留的历史行数（避免全量覆盖）
# 认证参数
AUTH_URL="http://172.16.253.121/quickauth.do"
WLAN_AC_NAME="NFV-BASE-SGYD2"
WLAN_AC_IP="172.16.253.114"
VLAN="1116"
RESPONSE_FILE="/tmp/response.txt"

# --------------------------
# 2. 工具函数（轻量化，不依赖额外工具）
# --------------------------
# 日志清理：避免全量覆盖，保留最近LOG_RESERVE_LINES行
clean_log() {
    # 确保日志目录存在（避免首次运行目录不存在）
    [ -d "$(dirname "$LOG_FILE")" ] || mkdir -p "$(dirname "$LOG_FILE")"
    
    local log_lines=$(wc -l < "$LOG_FILE" 2>/dev/null)
    if [ "$log_lines" -gt "$LOG_MAX_LINES" ]; then
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        # 保留历史日志，再追加清理提示（避免丢失之前的状态）
        tail -n "$LOG_RESERVE_LINES" "$LOG_FILE" > "$LOG_FILE.tmp"
        mv "$LOG_FILE.tmp" "$LOG_FILE"
        echo "[$timestamp] 日志行数($log_lines)超上限($LOG_MAX_LINES)，保留最近$LOG_RESERVE_LINES行" >> "$LOG_FILE"
    fi
}

# 网络检测：带超时，避免脚本阻塞
check_network() {
    # ping优化：-W 2（2秒超时）、-q（安静模式），减少阻塞和冗余输出
    ping -c 1 -W 2 -q "$PING_TARGET" >/dev/null 2>&1
    return $?
}

# 获取实时参数：每次认证前重新获取，避免缓存旧值（IP/MAC/时间戳）
get_real_time_params() {
    # 实时获取账号密码（支持运行中修改uci配置）
    local user=$(uci get autoweblogin.config.user_account 2>/dev/null)
    local pass=$(uci get autoweblogin.config.user_password 2>/dev/null)
    # 实时获取eth1 IP（过滤无效值，避免空值）
    local wlan_ip=$(ifconfig eth1 2>/dev/null | grep 'inet addr:' | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)
    # 实时获取eth1 MAC（统一大写，避免格式问题）
    local mac=$(ifconfig eth1 2>/dev/null | grep -oE '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}' | tr 'a-f' 'A-F')
    # 实时生成毫秒级时间戳（避免缓存旧值导致认证失败）
    local sec=$(date -u +%s)
    local nsec=$(date -u +%N)
    local ms=$((sec * 1000 + nsec / 1000000))
    
    # 返回参数（用空格分隔，后续用read解析）
    echo "$user $pass $wlan_ip $mac $ms"
}

# --------------------------
# 3. 认证核心函数（优化日志与安全性）
# --------------------------
portal() {
    local user="$1"
    local pass="$2"
    local wlan_ip="$3"
    local mac="$4"
    local ms="$5"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # 清理旧响应文件
    rm -f "$RESPONSE_FILE"

    # 日志输出：密码脱敏（避免明文泄露），仅显示前6位+***
    echo "[$timestamp] 请求参数：" >> "$log_file"
    echo "[$timestamp]   账号：$user" >> "$log_file"
    echo "[$timestamp]   密码：${pass:0:6}***" >> "$log_file"

    # 发起认证请求：curl优化（超时控制，避免长期阻塞）
    curl -s -S -o "$RESPONSE_FILE" --connect-timeout 5 --max-time 10 \
        "$AUTH_URL?userid=$user&passwd=$pass&wlanuserip=$wlan_ip&wlanacname=$WLAN_AC_NAME&wlanacIp=$WLAN_AC_IP&ssid=&vlan=$VLAN&mac=$mac&version=0&portalpageid=2&timestamp=$ms&portaltype=0&hostname=HuaWei&bindCtrlId=&validateType=0&bindOperatorType=2&sendFttrNotice=0"

    # 解析响应：截断长响应（避免日志膨胀），保留核心信息
    local response=$(cat "$RESPONSE_FILE" 2>/dev/null | tr -d '\r\n' | cut -c 1-200)
    echo "[$timestamp] 服务器返回（前200字符）：$response" >> "$log_file"

    # 清理临时文件
    rm -f "$RESPONSE_FILE"
}

# --------------------------
# 4. 主逻辑（扁平化循环，保留原流程）
# --------------------------
# 初始化日志
local init_timestamp=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$init_timestamp] 自动认证脚本开始运行" >> "$log_file"
clean_log  # 首次运行清理日志（避免继承旧日志）

while true; do
    # 阶段1：网络正常监测（循环等待，直到网络异常）
    while check_network; do
        sleep "$PING_INTERVAL"
        clean_log  # 定期清理日志，避免长期正常导致日志膨胀
    done

    # 阶段2：网络异常二次确认（避免ping波动误判）
    clean_log  # 异常时先清理日志，避免覆盖关键信息
    local err_timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$err_timestamp] 网络异常，$RECHECK_INTERVAL秒后进行二次监测" >> "$log_file"
    sleep "$RECHECK_INTERVAL"
    
    # 二次检测正常则回到阶段1，异常则进入认证
    if check_network; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 二次监测网络正常" >> "$log_file"
        continue
    fi

    # 阶段3：网络异常认证（循环重试，直到网络恢复）
    while true; do
        # 实时获取参数（避免使用启动时的旧值）
        read -r USER_ACCOUNT USER_PASSWORD WLAN_USER_IP MAC Milliseconds <<< $(get_real_time_params)
        
        # 参数校验：空值时跳过本次认证，避免无效请求
        if [ -z "$USER_ACCOUNT" ] || [ -z "$USER_PASSWORD" ] || [ -z "$WLAN_USER_IP" ] || [ -z "$MAC" ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证参数缺失（账号/密码），跳过本次认证" >> "$log_file"
            sleep "$RECHECK_INTERVAL"
            continue
        fi

        # 发起认证
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 网络异常，发起认证请求..." >> "$log_file"
        portal "$USER_ACCOUNT" "$USER_PASSWORD" "$WLAN_USER_IP" "$MAC" "$Milliseconds"

        # 认证后检测网络状态
        sleep "$RECHECK_INTERVAL"
        if check_network; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证成功" >> "$log_file"
            break  # 网络恢复，回到阶段1
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 认证失败，$RECHECK_INTERVAL秒后重试..." >> "$log_file"
            sleep "$RECHECK_INTERVAL"
        fi
    done
done
