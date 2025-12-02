#!/bin/bash

# 定义您的 SSH 公钥
SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNxsE0W7du7ObU+/v9XUa7nnFz3HYaQSUASnu5/3fj4J9E0vHJ0eniN4pxyfXs7yeeCeyZXUs4nSlzyAx0whTKrrXmYXdouqNVTO34LbWMB8vQUAHXUtcu40sAD4aAx75Ft/xPLQGKwMgMyUpf5wDhJ7GMDPeFok0h2wmSIRiizYUGMhq6TciTBUPcY6KaMcAygWhRqcVDTu1Glq+BzVFzzB/YKcc7o8omtVV096mjofYl2sBWLsfxg/r1H+rihuiYUrRJ3Ma3PwxCI6go3iw56zedoIG7mj/BZ3mPl+8vvdwkqKn2vPcfQfAHoAtSrOMXJ9vCrr4+T4f9BBhPmGMT"

# 使用知名的重装脚本：萌咖的一键重装脚本
wget -O reinstall.sh https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh
chmod +x reinstall.sh

# 选择 Ubuntu 24.04 LTS（更稳定）
OS="ubuntu"
VERSION="24.04"
SSH_PORT="36022"
# 生成随机密码
PASSWORD=$(openssl rand -base64 12)

echo "即将安装 $OS $VERSION"
echo "SSH 端口: $SSH_PORT"
echo "SSH 密钥已配置"

# 执行安装（Debian/Ubuntu 系统）
./reinstall.sh -d $VERSION -v 64 -p "$PASSWORD" -port $SSH_PORT -a

# 如果失败，尝试其他参数
if [ $? -ne 0 ]; then
    echo "尝试另一种安装方法..."
    # 使用 -firmware 参数包含固件
    ./reinstall.sh -d $VERSION -v 64 -p "$PASSWORD" -port $SSH_PORT -a -firmware
fi
