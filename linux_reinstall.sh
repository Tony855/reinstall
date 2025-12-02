#!/bin/bash

# 定义您的 SSH 公钥
SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNxsE0W7du7ObU+/v9XUa7nnFz3HYaQSUASnu5/3fj4J9E0vHJ0eniN4pxyfXs7yeeCeyZXUs4nSlzyAx0whTKrrXmYXdouqNVTO34LbWMB8vQUAHXUtcu40sAD4aAx75Ft/xPLQGKwMgMyUpf5wDhJ7GMDPeFok0h2wmSIRiizYUGMhq6TciTBUPcY6KaMcAygWhRqcVDTu1Glq+BzVFzzB/YKcc7o8omtVV096mjofYl2sBWLsfxg/r1H+rihuiYUrRJ3Ma3PwxCI6go3iw56zedoIG7mj/BZ3mPl+8vvdwkqKn2vPcfQfAHoAtSrOMXJ9vCrr4+T4f9BBhPmGMT"

# 下载安装脚本
wget -O reinstall.sh https://raw.githubusercontent.com/Tony855/reinstall/refs/heads/main/reinstall.sh
chmod +x reinstall.sh

# 选择要安装的系统（修改这里的值）
OS="ubuntu"
VERSION="24.04"
EXTRA_OPTIONS="--minimal"  # 如：--minimal --ci
SSH_PORT="36022"

# 添加修复：强制处理 dpkg 错误并忽略服务管理错误
# 创建临时的修复脚本
cat > /tmp/fix_dpkg.sh << 'EOF'
#!/bin/bash
# 防止 dpkg 在 chroot 环境中尝试停止服务
echo "#!/bin/sh" > /usr/sbin/rc-service
echo "exit 0" >> /usr/sbin/rc-service
chmod +x /usr/sbin/rc-service

# 防止 dpkg 在 chroot 环境中执行服务操作
mkdir -p /usr/sbin/invoke-rc.d
echo "#!/bin/sh" > /usr/sbin/invoke-rc.d
echo "exit 0" >> /usr/sbin/invoke-rc.d
chmod +x /usr/sbin/invoke-rc.d
EOF

chmod +x /tmp/fix_dpkg.sh

# 执行修复脚本（在 chroot 环境中执行）
echo "正在修复 chroot 环境问题..."

# 执行安装，添加修复选项
./reinstall.sh $OS $VERSION $EXTRA_OPTIONS --ssh-key "$SSH_KEY" --ssh-port "$SSH_PORT" --pre-fix "/tmp/fix_dpkg.sh"
