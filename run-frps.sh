#!/bin/bash

git config --global user.name "John Doe"
git config --global user.email johndoe@example.com

# 设置变量
MCP_FRP_DIR=$HOME/code/mcp-frp
FRP_VERSION="0.63.0"
FRP_ARCH="linux_amd64"
FRP_URL="https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_${FRP_ARCH}.tar.gz"
FRP_DIR="$MCP_FRP_DIR/frp_${FRP_VERSION}_${FRP_ARCH}"

echo "找到 mcp-frp 目录: $MCP_FRP_DIR"
cd "$MCP_FRP_DIR"

# 检查是否已经下载和解压
if [ ! -d "$FRP_DIR" ]; then
    echo "下载 frp ${FRP_VERSION}..."
    
    # 下载文件
    if ! wget "$FRP_URL" -O "frp_${FRP_VERSION}_${FRP_ARCH}.tar.gz"; then
        echo "下载失败，请检查网络连接"
        exit 1
    fi
    
    echo "解压文件..."
    tar -xzf "frp_${FRP_VERSION}_${FRP_ARCH}.tar.gz"
    
    if [ $? -ne 0 ]; then
        echo "解压失败"
        exit 1
    fi
    
    echo "清理下载文件..."
    rm -f "frp_${FRP_VERSION}_${FRP_ARCH}.tar.gz"
else
    echo "frp 已存在，跳过下载和解压"
fi

# 检查 frps 可执行文件是否存在
if [ ! -f "$FRP_DIR/frps" ]; then
    echo "错误: frps 可执行文件不存在"
    exit 1
fi

# 创建最简单的 frps 配置
echo "创建 frps 配置文件..."
cat > "$FRP_DIR/frps.toml" << 'EOF'
# frps 最简单配置
bindPort = 7001

# Web 管理界面（可选）
webServer.addr = "0.0.0.0"
webServer.port = 7501
webServer.user = "admin"
webServer.password = "admin"

# 日志配置
log.to = "./frps.log"
log.level = "info"
EOF

# 设置执行权限
chmod +x "$FRP_DIR/frps"

echo "配置完成！"
echo "frps 配置文件位置: $FRP_DIR/frps.toml"
echo "默认端口配置:"
echo "  - 主服务端口: 7001"
echo "  - Web管理界面: 7501 (用户名: admin, 密码: admin)"

# 启动 frps
echo "启动 frps 服务器..."
cd "$FRP_DIR"

# 检查端口是否被占用
if netstat -tuln | grep -q ":7001 "; then
    echo "警告: 端口 7001 已被占用"
    echo "请停止占用该端口的进程或修改配置文件中的 bindPort"
    exit 1
fi

# 启动服务
echo "正在启动 frps..."
echo "配置文件: $FRP_DIR/frps.toml"
echo "日志文件: $FRP_DIR/frps.log"
echo "Web管理: http://your-server-ip:7501"
echo ""

# 检查是否指定后台运行
if [ "$1" = "-d" ] || [ "$1" = "--daemon" ]; then
    echo "以后台模式启动 frps..."
    nohup ./frps -c frps.toml > /dev/null 2>&1 &
    echo "frps 已在后台启动，PID: $!"
    echo "使用以下命令停止服务:"
    echo "  pkill -f 'frps -c frps.toml'"
    echo "查看日志:"
    echo "  tail -f $FRP_DIR/frps.log"
else
    echo "前台运行模式 (按 Ctrl+C 停止服务)"
    echo "如需后台运行，请使用: $0 -d"
    echo ""
    ./frps -c frps.toml
fi
