#!/bin/bash

# 选择要安装的系统
OS="ubuntu"
VERSION="24.04"
EXTRA_OPTIONS="--minimal"  # 如：--minimal --ci
SSH_PORT="36022"

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

# 查看脚本帮助信息，了解可用参数
echo "查看安装脚本的帮助信息..."
./reinstall.sh --help || true

# 显示安装信息
echo "========================================"
echo "系统重装信息"
echo "========================================"
echo "操作系统: $OS $VERSION"
echo "安装选项: $EXTRA_OPTIONS"
echo "SSH端口: $SSH_PORT"
echo "SSH密钥: 已配置"
echo "========================================"
echo "警告：此操作将完全重装系统，所有数据将被清除！"
echo "========================================"

# 询问用户是否继续
read -p "是否继续安装？(y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "安装已取消"
    exit 0
fi

# 执行安装
echo "开始安装系统..."
echo "参数: $OS $VERSION $EXTRA_OPTIONS --ssh-key 'SSH_KEY_HIDDEN' --ssh-port $SSH_PORT"
./reinstall.sh $OS $VERSION $EXTRA_OPTIONS --ssh-key "$SSH_KEY" --ssh-port "$SSH_PORT"

# 记录安装结果
install_status=$?

# 询问是否重启系统
if [ $install_status -eq 0 ]; then
    echo "========================================"
    echo "系统安装完成！"
    echo "========================================"
    
    # 检测系统类型并配置防火墙
    echo "正在检测系统类型并配置防火墙规则..."
    
    # 检查是否为Ubuntu/Debian系统
    if [ -f /etc/debian_version ] || [ -f /etc/lsb-release ]; then
        echo "检测到Ubuntu/Debian系统，使用ufw配置防火墙..."
        
        # 安装ufw（如果未安装）
        if ! command -v ufw &> /dev/null; then
            echo "安装ufw防火墙..."
            apt-get update && apt-get install -y ufw
        fi
        
        # 启用ufw并配置规则
        echo "配置ufw防火墙规则..."
        ufw --force enable
        ufw allow "$SSH_PORT/tcp"
        ufw allow 80/tcp
        ufw allow 443/tcp
        ufw --force reload
        echo "ufw防火墙规则已更新，SSH端口 $SSH_PORT 已允许"
        
    # 检查是否为CentOS/RHEL/Fedora系统
    elif [ -f /etc/redhat-release ] || [ -f /etc/fedora-release ]; then
        echo "检测到CentOS/RHEL/Fedora系统，使用firewalld配置防火墙..."
        
        # 检查firewalld是否安装
        if ! command -v firewall-cmd &> /dev/null; then
            echo "安装firewalld防火墙..."
            yum install -y firewalld || dnf install -y firewalld
            systemctl enable --now firewalld
        fi
        
        # 配置firewalld规则
        echo "配置firewalld防火墙规则..."
        firewall-cmd --permanent --add-port="$SSH_PORT/tcp"
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        firewall-cmd --reload
        echo "firewalld防火墙规则已更新，SSH端口 $SSH_PORT 已允许"
        
    # 检查是否为Arch Linux系统
    elif [ -f /etc/arch-release ]; then
        echo "检测到Arch Linux系统，使用iptables配置防火墙..."
        
        # 使用iptables配置
        iptables -A INPUT -p tcp --dport "$SSH_PORT" -j ACCEPT
        iptables -A INPUT -p tcp --dport 80 -j ACCEPT
        iptables -A INPUT -p tcp --dport 443 -j ACCEPT
        
        # 保存iptables规则（如果有iptables-persistent）
        if command -v iptables-save &> /dev/null; then
            iptables-save > /etc/iptables/iptables.rules
        fi
        echo "iptables防火墙规则已更新，SSH端口 $SSH_PORT 已允许"
        
    else
        echo "未识别的系统类型，请手动配置防火墙规则"
        echo "请手动允许以下端口："
        echo "SSH端口: $SSH_PORT/tcp"
        echo "HTTP端口: 80/tcp"
        echo "HTTPS端口: 443/tcp"
    fi
    
    # 显示当前防火墙状态
    echo "========================================"
    echo "当前防火墙状态："
    if command -v ufw &> /dev/null; then
        ufw status verbose
    elif command -v firewall-cmd &> /dev/null; then
        firewall-cmd --list-all
    elif command -v iptables &> /dev/null; then
        iptables -L -n | grep "$SSH_PORT\|80\|443"
    fi
    echo "========================================"
    
    read -p "是否立即重启系统？(y/N): " reboot_confirm
    if [[ "$reboot_confirm" =~ ^[Yy]$ ]]; then
        echo "系统将在10秒后重启..."
        echo "请使用以下信息连接新系统："
        echo "- SSH端口: $SSH_PORT"
        echo "- 使用配置的SSH密钥连接"
        echo "倒计时开始..."
        
        for i in {10..1}; do
            echo "$i 秒后重启..."
            sleep 1
        done
        
        echo "正在重启系统..."
        reboot
    else
        echo "请手动重启系统以使更改生效。"
        echo "重启后请使用以下信息连接："
        echo "- SSH端口: $SSH_PORT"
        echo "- 使用配置的SSH密钥连接"
    fi
else
    echo "========================================"
    echo "系统安装失败！错误代码: $install_status"
    echo "========================================"
    
    # 提供错误处理建议
    echo "可能的问题和解决方案："
    echo "1. 网络连接问题 - 检查网络连接"
    echo "2. 磁盘空间不足 - 清理磁盘空间"
    echo "3. 安装源问题 - 尝试更换镜像源"
    echo "4. 脚本兼容性问题 - 尝试其他重装脚本"
    
    read -p "是否尝试清理环境并重试？(y/N): " retry_confirm
    if [[ "$retry_confirm" =~ ^[Yy]$ ]]; then
        # 清理环境
        echo "清理环境..."
        rm -f reinstall.sh
        apt-get clean
        apt-get autoremove -y
        
        # 重新下载并执行
        echo "重新尝试安装..."
        bash $0
    else
        echo "安装已中止。请检查上述错误信息。"
    fi
fi
