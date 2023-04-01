#!/bin/bash

# 请在这里填写您的Telegram机器人API密钥和群组聊天ID
TELEGRAM_BOT_API_KEY="YOUR_TELEGRAM_BOT_API_KEY"
TELEGRAM_GROUP_CHAT_ID="YOUR_TELEGRAM_GROUP_CHAT_ID"

# 安装宝塔面板
install_bt_panel() {
  yum install -y curl jq wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && echo y | bash install.sh 2>&1
}

# 发送Telegram消息
send_telegram_message() {
  local message="$1"
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_API_KEY}/sendMessage" -F "chat_id=${TELEGRAM_GROUP_CHAT_ID}" -F "text=${message}" -F "parse_mode=HTML"
}

# 主函数
main() {
  local output=$(install_bt_panel)

  # 等待3分钟
  sleep 180

  local start_time=$(date +%s)
  local elapsed_time=0
  local timeout=900 # 设置超时时间为15分钟

  while [ $elapsed_time -lt $timeout ]; do
    if [ -f /www/server/panel/data/admin_path.pl ]; then
      local login_ip=$(curl -s ipinfo.io/ip)
      local login_port=$(cat /www/server/panel/data/port.pl)
      local security_entry=$(cat /www/server/panel/data/admin_path.pl)

      local username=$(echo "$output" | grep -m 1 "username" | awk -F' ' '{print $2}')
      local password=$(echo "$output" | grep -m 1 "password" | awk -F' ' '{print $2}')

      local login_url="http://${login_ip}:${login_port}${security_entry}"
      local message="宝塔面板已安装成功！&#10;登录地址: ${login_url}&#10;用户名: ${username}&#10;密码: ${password}"
      send_telegram_message "$message"
      rm -- "$0" # 删除脚本本身
      exit 0
    fi

    sleep 10
    elapsed_time=$(($(date +%s) - $start_time))
  done

  local public_ip=$(curl -s ipinfo.io/ip)
  send_telegram_message "宝塔面板安装可能失败，请检查。服务器公网IP: ${public_ip}"
  rm -- "$0" # 删除脚本本身
}

main
