#!/bin/bash

# 下载安装脚本
wget -O reinstall.sh https://raw.githubusercontent.com/Tony855/reinstall/refs/heads/main/reinstall.sh
chmod +x reinstall.sh

# 使用自定义 ISO 链接:
# bash reinstall.sh windows --image-name="windows 11 pro" --iso="https://example.com/windows11.iso" --lang=en-us

# 安装 Windows 11 专业版（简体中文）
./reinstall.sh windows --image-name="windows 11 pro" --lang=zh-cn --password="Hcd@10086"

# 安装 Windows 11 专业版（英文）
# ./reinstall.sh windows --image-name="windows 11 pro" --lang=en-us --password="Hcd@10086"

# 或者安装 Windows 10 企业版（简体中文）
# ./reinstall.sh windows --image-name="windows 10 enterprise" --lang=zh-cn --password="Hcd@10086"

# 或者安装 Windows Server 2022 数据中心版
# ./reinstall.sh windows --image-name="windows server 2022 serverdatacenter" --lang=en-us

# 设置管理员密码：
# bash reinstall.sh windows --image-name="windows 11 pro" --lang=en-us --password="YourPassword123"

# 设置 RDP 端口：
# bash reinstall.sh windows --image-name="windows 11 pro" --lang=en-us --rdp-port=33389

# 添加自定义驱动程序：
# bash reinstall.sh windows --image-name="windows 11 pro" --lang=en-us --add-driver="/path/to/drivers"

# 允许 ping：
# bash reinstall.sh windows --image-name="windows 11 pro" --lang=en-us --allow-ping