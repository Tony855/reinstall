#!/bin/bash
apt update && apt install wget -y 
# 定义您的 SSH 公钥
SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNxsE0W7du7ObU+/v9XUa7nnFz3HYaQSUASnu5/3fj4J9E0vHJ0eniN4pxyfXs7yeeCeyZXUs4nSlzyAx0whTKrrXmYXdouqNVTO34LbWMB8vQUAHXUtcu40sAD4aAx75Ft/xPLQGKwMgMyUpf5wDhJ7GMDPeFok0h2wmSIRiizYUGMhq6TciTBUPcY6KaMcAygWhRqcVDTu1Glq+BzVFzzB/YKcc7o8omtVV096mjofYl2sBWLsfxg/r1H+rihuiYUrRJ3Ma3PwxCI6go3iw56zedoIG7mj/BZ3mPl+8vvdwkqKn2vPcfQfAHoAtSrOMXJ9vCrr4+T4f9BBhPmGMT"

# 下载安装脚本
wget https://raw.githubusercontent.com/Tony855/reinstall/refs/heads/main/reinstall.sh
chmod +x reinstall.sh

# 选择要安装的系统（修改这里的值）
OS="ubuntu"
VERSION="24.04"
EXTRA_OPTIONS="--minimal"  # 如：--minimal --ci
SSH_PORT="36022"

# 执行安装
./reinstall.sh $OS $VERSION $EXTRA_OPTIONS --ssh-key "$SSH_KEY" --ssh-port "$SSH_PORT"
