#!/bin/bash

# 更新并安装必要的工具
apt-get update && apt-get install -y wget

# 定义您的 SSH 公钥
SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNxsE0W7du7ObU+/v9XUa7nnFz3HYaQSUASnu5/3fj4J9E0vHJ0eniN4pxyfXs7yeeCeyZXUs4nSlzyAx0whTKrrXmYXdouqNVTO34LbWMB8vQUAHXUtcu40sAD4aAx75Ft/xPLQGKwMgMyUpf5wDhJ7GMDPeFok0h2wmSIRiizYUGMhq6TciTBUPcY6KaMcAygWhRqcVDTu1Glq+BzVFzzB/YKcc7o8omtVV096mjofYl2sBWLsfxg/r1H+rihuiYUrRJ3Ma3PwxCI6go3iw56zedoIG7mj/BZ3mPl+8vvdwkqKn2vPcfQfAHoAtSrOMXJ9vCrr4+T4f9BBhPmGMT"

# 清理可能存在的旧文件
rm -f reinstall.sh

# 下载安装脚本（使用完整URL并检查是否成功）
echo "正在下载安装脚本..."
wget --no-check-certificate -O reinstall.sh "https://raw.githubusercontent.com/Tony855/reinstall/refs/heads/main/reinstall.sh"

# 检查下载是否成功
if [ ! -f "reinstall.sh" ]; then
    echo "下载失败，尝试使用备用方法..."
    curl -L -o reinstall.sh "https://raw.githubusercontent.com/Tony855/reinstall/refs/heads/main/reinstall.sh"
    
    if [ ! -f "reinstall.sh" ]; then
        echo "错误：无法下载安装脚本！"
        exit 1
    fi
fi

# 给脚本执行权限
chmod +x reinstall.sh

# 检查脚本是否可执行
if [ ! -x "reinstall.sh" ]; then
    echo "错误：无法给脚本执行权限！"
    exit 1
fi

# 选择要安装的系统
OS="ubuntu"
VERSION="24.04"
EXTRA_OPTIONS="--minimal"  # 如：--minimal --ci
SSH_PORT="36022"

# 查看脚本帮助信息，了解可用参数
echo "查看安装脚本的帮助信息..."
./reinstall.sh --help || true

# 执行安装
echo "开始安装系统..."
echo "参数: $OS $VERSION $EXTRA_OPTIONS --ssh-key 'SSH_KEY_HIDDEN' --ssh-port $SSH_PORT"
./reinstall.sh $OS $VERSION $EXTRA_OPTIONS --ssh-key "$SSH_KEY" --ssh-port "$SSH_PORT"
