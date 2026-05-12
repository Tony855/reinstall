#!/bin/bash

# 默认配置
DEFAULT_OS="Ubuntu"
DEFAULT_VERSION=""  # 空版本表示最新稳定版
DEFAULT_EXTRA_OPTIONS="--ci"  # 如：--minimal --ci
DEFAULT_SSH_PORT="22"

# 定义您的 SSH 公钥
SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNxsE0W7du7ObU+/v9XUa7nnFz3HYaQSUASnu5/3fj4J9E0vHJ0eniN4pxyfXs7yeeCeyZXUs4nSlzyAx0whTKrrXmYXdouqNVTO34LbWMB8vQUAHXUtcu40sAD4aAx75Ft/xPLQGKwMgMyUpf5wDhJ7GMDPeFok0h2wmSIRiizYUGMhq6TciTBUPcY6KaMcAygWhRqcVDTu1Glq+BzVFzzB/YKcc7o8omtVV096mjofYl2sBWLsfxg/r1H+rihuiYUrRJ3Ma3PwxCI6go3iw56zedoIG7mj/BZ3mPl+8vvdwkqKn2vPcfQfAHoAtSrOMXJ9vCrr4+T4f9BBhPmGMT"

# 操作系统选项菜单
show_os_menu() {
    clear
    echo "========================================"
    echo "          Linux 系统安装助手"
    echo "========================================"
    echo ""
    echo "请选择要安装的操作系统："
    echo "1. Debian"
    echo "2. Ubuntu"
    echo "3. CentOS"
    echo "4. AlmaLinux"
    echo "5. RockyLinux"
    echo "6. 其他 (手动输入)"
    echo "7. 退出"
    echo ""
    echo "========================================"
}

# 版本选择菜单
show_version_menu() {
    local os="$1"
    
    clear
    echo "========================================"
    echo "         $os 版本选择"
    echo "========================================"
    echo ""
    
    case "$os" in
        Debian)
            echo "1. Debian 12 (Bookworm) - 当前稳定版"
            echo "2. Debian 11 (Bullseye) - 旧稳定版"
            echo "3. Debian 10 (Buster)   - 旧稳定版"
            echo "4. 最新稳定版 (默认) - 推荐"
            echo "5. 不指定版本 (使用最新)"
            echo "6. 手动输入版本号"
            ;;
        Ubuntu)
            echo "1. Ubuntu 24.04 (Noble Numbat) - 最新LTS"
            echo "2. Ubuntu 22.04 (Jammy Jellyfish) - LTS"
            echo "3. Ubuntu 20.04 (Focal Fossa) - LTS"
            echo "4. 最新LTS版 (默认) - 推荐"
            echo "5. 不指定版本 (使用最新)"
            echo "6. 手动输入版本号"
            ;;
        CentOS)
            echo "1. CentOS 9 Stream"
            echo "2. CentOS 8 Stream"
            echo "3. 最新版 (默认) - 推荐"
            echo "4. 不指定版本"
            echo "5. 手动输入版本号"
            echo "注意：CentOS 7 已停止维护"
            ;;
        AlmaLinux|RockyLinux)
            echo "1. 9.x 系列 (最新)"
            echo "2. 8.x 系列"
            echo "3. 最新稳定版 (默认) - 推荐"
            echo "4. 不指定版本"
            echo "5. 手动输入版本号"
            ;;
        *)
            echo "1. 最新稳定版 (默认) - 推荐"
            echo "2. 不指定版本"
            echo "3. 手动输入版本号"
            ;;
    esac
    
    echo ""
    echo "========================================"
}

# 获取版本号
get_version() {
    local os="$1"
    local choice="$2"
    
    case "$os" in
        Debian)
            case "$choice" in
                1) echo "12" ;;
                2) echo "11" ;;
                3) echo "10" ;;
                4) echo "" ;;       # 空字符串表示最新稳定版
                5) echo "" ;;       # 空字符串表示不指定版本
                6) 
                    read -p "请输入 Debian 版本号 (如: 12, 11, 10): " custom_version
                    echo "$custom_version"
                    ;;
                *) echo "" ;;       # 默认返回空
            esac
            ;;
        Ubuntu)
            case "$choice" in
                1) echo "24.04" ;;
                2) echo "22.04" ;;
                3) echo "20.04" ;;
                4) echo "" ;;       # 空字符串表示最新LTS版
                5) echo "" ;;       # 空字符串表示不指定版本
                6) 
                    read -p "请输入 Ubuntu 版本号 (如: 24.04, 22.04): " custom_version
                    echo "$custom_version"
                    ;;
                *) echo "" ;;
            esac
            ;;
        CentOS)
            case "$choice" in
                1) echo "9" ;;
                2) echo "8" ;;
                3) echo "" ;;       # 空字符串表示最新版
                4) echo "" ;;       # 空字符串表示不指定版本
                5) 
                    read -p "请输入 CentOS 版本号 (如: 9, 8): " custom_version
                    echo "$custom_version"
                    ;;
                *) echo "" ;;
            esac
            ;;
        AlmaLinux|RockyLinux)
            case "$choice" in
                1) echo "9" ;;
                2) echo "8" ;;
                3) echo "" ;;       # 空字符串表示最新稳定版
                4) echo "" ;;       # 空字符串表示不指定版本
                5) 
                    read -p "请输入 $os 版本号 (如: 9, 8): " custom_version
                    echo "$custom_version"
                    ;;
                *) echo "" ;;
            esac
            ;;
        *)
            case "$choice" in
                1) echo "" ;;       # 空字符串表示最新稳定版
                2) echo "" ;;       # 空字符串表示不指定版本
                3) 
                    read -p "请输入 $os 版本号: " custom_version
                    echo "$custom_version"
                    ;;
                *) echo "" ;;
            esac
            ;;
    esac
}

# 交互式配置
interactive_config() {
    # 选择操作系统
    while true; do
        show_os_menu
        read -p "请输入选择 [1-7] (默认: 1): " os_choice
        
        case "$os_choice" in
            1|"") 
                OS="Debian"
                break
                ;;
            2) 
                OS="Ubuntu"
                break
                ;;
            3) 
                OS="CentOS"
                break
                ;;
            4) 
                OS="AlmaLinux"
                break
                ;;
            5) 
                OS="RockyLinux"
                break
                ;;
            6)
                read -p "请输入操作系统名称: " custom_os
                if [ -n "$custom_os" ]; then
                    OS="$custom_os"
                    break
                else
                    echo "操作系统名称不能为空！"
                    sleep 2
                fi
                ;;
            7)
                echo "退出安装程序"
                exit 0
                ;;
            *)
                echo "无效选择，请重新输入！"
                sleep 2
                ;;
        esac
    done
    
    # 选择版本
    show_version_menu "$OS"
    read -p "请输入选择 [1-6] (默认根据系统不同): " version_choice
    VERSION=$(get_version "$OS" "$version_choice")
    
    # 如果用户没有输入选择，则使用默认值
    if [ -z "$version_choice" ]; then
        # 根据操作系统设置默认版本选择
        case "$OS" in
            Debian) VERSION="" ;;  # Debian默认使用最新稳定版
            Ubuntu) VERSION="" ;;  # Ubuntu默认使用最新LTS版
            CentOS) VERSION="" ;;  # CentOS默认使用最新版
            *) VERSION="" ;;       # 其他系统默认不指定版本
        esac
    fi
    
    # 配置额外选项
    echo ""
    echo "========================================"
    echo "         额外安装选项"
    echo "========================================"
    echo "可选选项:"
    echo "1. --minimal      (最小化安装) - 推荐"
    echo "2. --ci           (适合CI/CD环境)"
    echo "3. --firmware     (包含固件)"
    echo "4. --no-docker    (不安装Docker)"
    echo "5. 自定义选项"
    echo "6. 无额外选项 (默认最小化安装)"
    echo "0. 跳过额外选项配置"
    echo ""
    read -p "请选择额外选项 (可多选，用逗号分隔，如: 1,3): " extra_choices
    
    # 设置默认值
    if [ -z "$extra_choices" ]; then
        EXTRA_OPTIONS="--minimal"
    else
        EXTRA_OPTIONS=""
        IFS=',' read -ra choices <<< "$extra_choices"
        for choice in "${choices[@]}"; do
            case "$choice" in
                1) EXTRA_OPTIONS+=" --minimal" ;;
                2) EXTRA_OPTIONS+=" --ci" ;;
                3) EXTRA_OPTIONS+=" --firmware" ;;
                4) EXTRA_OPTIONS+=" --no-docker" ;;
                5) 
                    read -p "请输入自定义选项 (如: --mirror http://mirrors.aliyun.com/debian): " custom_option
                    EXTRA_OPTIONS+=" $custom_option"
                    ;;
                6) EXTRA_OPTIONS="" ;;  # 清空选项
                0) EXTRA_OPTIONS="" ;;  # 清空选项
            esac
        done
    fi
    
    # 配置SSH端口
    echo ""
    read -p "请输入SSH端口号 [默认: $DEFAULT_SSH_PORT]: " ssh_port_input
    if [ -n "$ssh_port_input" ]; then
        SSH_PORT="$ssh_port_input"
    else
        SSH_PORT="$DEFAULT_SSH_PORT"
    fi
    
    # 确认配置
    clear
    echo "========================================"
    echo "          安装配置确认"
    echo "========================================"
    echo "操作系统: $OS"
    if [ -z "$VERSION" ]; then
        echo "版本: 最新稳定版 (未指定版本)"
    else
        echo "版本: $VERSION"
    fi
    if [ -z "$EXTRA_OPTIONS" ]; then
        echo "额外选项: 无"
    else
        echo "额外选项: $EXTRA_OPTIONS"
    fi
    echo "SSH端口: $SSH_PORT"
    echo "SSH密钥: 已配置"
    echo "========================================"
    echo "注意：版本为空表示安装最新稳定版"
    echo "========================================"
    
    read -p "确认配置是否正确？(y/N): " confirm_config
    if [[ ! "$confirm_config" =~ ^[Yy]$ ]]; then
        echo "重新配置..."
        interactive_config
    fi
}

# 安装工具
install_tools() {
    echo "正在安装必要工具..."
    apt-get update >/dev/null 2>&1 || yum makecache >/dev/null 2>&1 || dnf makecache >/dev/null 2>&1 || true
    apt-get install -y curl wget >/dev/null 2>&1 || yum install -y curl wget >/dev/null 2>&1 || dnf install -y curl wget >/dev/null 2>&1 || {
        echo "尝试安装必要工具..."
        # 尝试使用通用方法
        if command -v curl >/dev/null 2>&1; then
            echo "curl 已安装"
        else
            echo "请手动安装 curl 工具"
            exit 1
        fi
        
        if command -v wget >/dev/null 2>&1; then
            echo "wget 已安装"
        else
            echo "请手动安装 wget 工具"
            exit 1
        fi
    }
}

# 构建安装命令
build_install_cmd() {
    local cmd="./reinstall.sh $OS"
    
    # 添加版本（如果存在）
    if [ -n "$VERSION" ]; then
        cmd="$cmd $VERSION"
    fi
    
    # 添加额外选项（如果存在）
    if [ -n "$EXTRA_OPTIONS" ]; then
        cmd="$cmd $EXTRA_OPTIONS"
    fi
    
    # 添加SSH配置
    cmd="$cmd --ssh-key \"$SSH_KEY\" --ssh-port \"$SSH_PORT\""
    
    echo "$cmd"
}

# 主安装函数
main_install() {
    # 清理可能存在的旧文件
    rm -f reinstall.sh

    # 下载安装脚本
    echo "正在下载安装脚本..."
    wget --no-check-certificate -q -O reinstall.sh "https://raw.githubusercontent.com/Tony855/reinstall/refs/heads/main/reinstall.sh"

    # 检查下载是否成功
    if [ ! -f "reinstall.sh" ]; then
        echo "下载失败，尝试使用备用方法..."
        curl -L -s -o reinstall.sh "https://raw.githubusercontent.com/Tony855/reinstall/refs/heads/main/reinstall.sh"
        
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

    # 最终确认
    echo ""
    echo "========================================"
    echo "          最终警告"
    echo "========================================"
    echo "系统重装信息："
    echo "操作系统: $OS"
    if [ -z "$VERSION" ]; then
        echo "版本: 最新稳定版"
    else
        echo "版本: $VERSION"
    fi
    echo "安装选项: ${EXTRA_OPTIONS:--minimal}"
    echo "SSH端口: $SSH_PORT"
    echo ""
    echo "⚠️  警告：此操作将完全重装系统，所有数据将被清除！"
    echo "⚠️  请确保已经备份重要数据！"
    echo "========================================"

    read -p "是否继续安装？(y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "安装已取消"
        exit 0
    fi

    # 构建并执行安装命令
    INSTALL_CMD=$(build_install_cmd)
    
    echo ""
    echo "开始安装系统..."
    echo "执行命令: $INSTALL_CMD"
    echo ""
    
    # 执行安装命令
    eval $INSTALL_CMD
}

# 结果处理
handle_result() {
    install_status=$?

    if [ $install_status -eq 0 ]; then
        echo ""
        echo "========================================"
        echo "     🎉 系统安装完成！"
        echo "========================================"
        echo ""
        echo "安装摘要："
        echo "- 操作系统: $OS"
        if [ -z "$VERSION" ]; then
            echo "- 版本: 最新稳定版"
        else
            echo "- 版本: $VERSION"
        fi
        echo "- SSH端口: $SSH_PORT"
        echo ""
        
        read -p "是否立即重启系统？(y/N): " reboot_confirm
        if [[ "$reboot_confirm" =~ ^[Yy]$ ]]; then
            echo "系统将在10秒后重启..."
            echo "请使用以下信息连接新系统："
            echo "- SSH端口: $SSH_PORT"
            echo "- 使用配置的SSH密钥连接"
            echo ""
            echo "倒计时开始..."
            
            for i in {10..1}; do
                echo "⏰ $i 秒后重启..."
                sleep 1
            done
            
            echo "正在重启系统..."
            reboot
        else
            echo ""
            echo "请手动重启系统以使更改生效。"
            echo "重启后请使用以下信息连接："
            echo "- SSH端口: $SSH_PORT"
            echo "- 使用配置的SSH密钥连接"
            echo ""
            echo "手动重启命令: reboot"
        fi
    else
        echo ""
        echo "========================================"
        echo "     ❌ 系统安装失败！"
        echo "========================================"
        echo "错误代码: $install_status"
        echo ""
        
        # 提供错误处理建议
        echo "可能的问题和解决方案："
        echo "1. 📡 网络连接问题 - 检查网络连接"
        echo "2. 💾 磁盘空间不足 - 清理磁盘空间"
        echo "3. 📦 安装源问题 - 尝试更换镜像源"
        echo "4. 🔧 脚本兼容性问题 - 检查系统兼容性"
        echo "5. 📄 参数错误 - 检查安装参数是否正确"
        echo ""
        
        read -p "是否尝试清理环境并重试？(y/N): " retry_confirm
        if [[ "$retry_confirm" =~ ^[Yy]$ ]]; then
            # 清理环境
            echo "清理环境..."
            rm -f reinstall.sh
            apt-get clean >/dev/null 2>&1 || true
            apt-get autoremove -y >/dev/null 2>&1 || true
            
            # 重新下载并执行
            echo "重新尝试安装..."
            main_install
            handle_result
        else
            echo ""
            echo "安装已中止。请检查上述错误信息。"
            echo "可以尝试："
            echo "1. 修改安装参数"
            echo "2. 更换安装脚本"
            echo "3. 手动安装系统"
        fi
    fi
}

# 主程序
main() {
    # 显示欢迎信息
    clear
    echo "========================================"
    echo "      🚀 Linux 系统重装助手"
    echo "========================================"
    echo ""
    echo "本脚本将帮助您重装 Linux 系统"
    echo "支持的系统：Debian, Ubuntu, CentOS, AlmaLinux, RockyLinux 等"
    echo ""
    echo "💡 提示：版本可以为空，表示安装最新稳定版"
    echo "⚠️  警告：重装会清除所有数据，请提前备份！"
    echo ""
    
    # 检查是否以root用户运行
    if [ "$EUID" -ne 0 ]; then
        echo "请以root用户运行此脚本！"
        echo "使用命令: sudo bash $0"
        exit 1
    fi
    
    # 交互式配置
    interactive_config
    
    # 安装必要工具
    install_tools
    
    # 执行安装
    main_install
    
    # 处理结果
    handle_result
}

# 运行主程序
main
