#!/bin/bash
# !bash /content/drive/MyDrive/code/colab-tricks/setupSSH.sh
mkdir -p ~/.ssh
# 读取setupSSH.sh相同路径下的id_rsa.pub文件
# 确保目录存在并设置正确权限
chmod 700 ~/.ssh
# 检查id_rsa.pub文件是否存在再进行操作
if [ -f "$(dirname "$0")/id_rsa.pub" ]; then
    cat "$(dirname "$0")/id_rsa.pub" >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
else
    echo "Warning: id_rsa.pub file not found in script directory"
fi

cat ~/.ssh/authorized_keys

# 更新包列表
apt update -y > /dev/null
# 可选：恢复完整 Ubuntu 环境（耗时较长，仅 SSH 可跳过）
yes | unminimize > /dev/null
apt install -y -qq -o=Dpkg::Use-Pty=0 openssh-server > /dev/null # pwgen net-tools psmisc pciutils htop neofetch zsh nano byobu

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

echo "ListenAddress 127.0.0.1" >> /etc/ssh/sshd_config

mkdir -p /run/sshd
/usr/sbin/sshd

# ssh -p 22 root@127.0.0.1