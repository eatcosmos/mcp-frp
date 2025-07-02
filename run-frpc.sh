#!/bin/bash

# 查找 mcp-frp 项目目录（colab 环境）
find_mcp_frp() {
    # 在当前目录及其父目录中查找 mcp-frp
    local current_dir=$(pwd)
    
    # 检查当前目录是否是 mcp-frp
    if [[ "$(basename "$current_dir")" == "mcp-frp" ]]; then
        echo "$current_dir"
        return 0
    fi
    
    # 在当前目录下查找
    if [ -d "./mcp-frp" ]; then
        echo "$(pwd)/mcp-frp"
        return 0
    fi
    
    # 在 HOME 下查找
    local found_dir=$(find "$HOME" -name "mcp-frp" -type d 2>/dev/null | head -1)
    if [ -n "$found_dir" ]; then
        echo "$found_dir"
        return 0
    fi
    
    # 在常见 colab 位置查找
    local colab_paths=("/content/mcp-frp" "/content/drive/MyDrive/mcp-frp")
    for path in "${colab_paths[@]}"; do
        if [ -d "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    echo "错误: 找不到 mcp-frp 目录"
    echo "请确保 mcp-frp 项目目录存在"
    exit 1
}

# 检查服务器 IP 环境变量
if [ -z "$FRPS_SERVER_IP" ]; then
    echo "错误: 未设置 FRPS_SERVER_IP 环境变量"
    echo "请设置服务器 IP 地址："
    echo "  export FRPS_SERVER_IP=your-server-ip"
    echo ""
    echo "或者在运行时指定："
    echo "  FRPS_SERVER_IP=your-server-ip $0"
    exit 1
fi

# 设置变量
MCP_FRP_DIR=$(find_mcp_frp)
FRP_VERSION="0.63.0"
FRP_ARCH="linux_amd64"
FRP_DIR="$MCP_FRP_DIR/frp_${FRP_VERSION}_${FRP_ARCH}"

echo "找到 mcp-frp 目录: $MCP_FRP_DIR"
echo "服务器 IP: $FRPS_SERVER_IP"
cd "$MCP_FRP_DIR"

# 检查 frp 是否存在
if [ ! -d "$FRP_DIR" ]; then
    echo "错误: frp 目录不存在: $FRP_DIR"
    echo "请先运行 run-frps.sh 下载 frp"
    exit 1
fi

# 检查 frpc 可执行文件是否存在
if [ ! -f "$FRP_DIR/frpc" ]; then
    echo "错误: frpc 可执行文件不存在"
    exit 1
fi

# 创建 frpc 客户端配置
echo "创建 frpc 配置文件..."
cat > "$FRP_DIR/frpc.toml" << EOF
# frpc 客户端配置
serverAddr = "$FRPS_SERVER_IP"
serverPort = 7001

# 日志配置
log.to = "./frpc.log"
log.level = "info"

# SSH 隧道配置（示例）
[[proxies]]
name = "ssh"
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = 6000

# Jupyter 配置（colab 常用）
[[proxies]]
name = "jupyter"
type = "tcp"
localIP = "127.0.0.1"
localPort = 8888
remotePort = 8888

# HTTP 服务配置（可选）
[[proxies]]
name = "web"
type = "http"
localIP = "127.0.0.1"
localPort = 8080
customDomains = ["your-domain.com"]
EOF

# 设置执行权限
chmod +x "$FRP_DIR/frpc"

echo "配置完成！"
echo "frpc 配置文件位置: $FRP_DIR/frpc.toml"
echo "隧道配置："
echo "  - SSH: $FRPS_SERVER_IP:6000 -> localhost:22"
echo "  - Jupyter: $FRPS_SERVER_IP:8888 -> localhost:8888"
echo "  - Web: your-domain.com -> localhost:8080"

# 启动 frpc
echo "启动 frpc 客户端..."
cd "$FRP_DIR"

# 检查是否指定后台运行
if [ "$1" = "-d" ] || [ "$1" = "--daemon" ]; then
    echo "以后台模式启动 frpc..."
    nohup ./frpc -c frpc.toml > /dev/null 2>&1 &
    echo "frpc 已在后台启动，PID: $!"
    echo "使用以下命令停止服务:"
    echo "  pkill -f 'frpc -c frpc.toml'"
    echo "查看日志:"
    echo "  tail -f $FRP_DIR/frpc.log"
else
    echo "前台运行模式 (按 Ctrl+C 停止服务)"
    echo "如需后台运行，请使用: $0 -d"
    echo ""
    echo "正在连接到服务器 $FRPS_SERVER_IP:7001..."
    ./frpc -c frpc.toml
fi
