#/bin/bash
# !bash /content/drive/MyDrive/code/colab-tricks/setupSSH.sh
mkdir -p ~/.ssh
# echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDP6FNjJvsc49car3uf7cVdHBBugKx7t6zqMdGubKq/bF3cPlDDbRu60PZOSRkgbC+HsCUSVfJv/QFajgqe7+nRYkeKEMEm40aBxJlzvPlB9ahrL/H55Wh6uSSjLQVs2k2xW7/k8YYyXWZPqoeTaerg0wxHE3YADpcbZJTSYf170hlbSbknVFlJJdAKM9Eq7yEATQoxoYzi479w7zC1Na4UI4puDyCcmH1FmYY7EfSCQdUd2vmXBHhrSn8KrJD9soA0pI4cN66EhqiO88Fqns3+yBXGayLDfp5abboO+JbBtLfFYxNtA32HPxwsU0lQkOP8tspCXNJdExFtCRoLZTHfPd7ITrEKAhTpNHwH9efjgrljjnVQb4is9d+347l2uhOya3JfdSYSi1LnaXstkHEvytnYs5oSiwybOprnVEfVfMqFIT/rr3GjxyTR9TEOX79t5ijWMKJGaeLQezEdrWx6scUMPidvojn+rH2X/NZ6vU4CLU9F93aP5aRRVNl91EE= ubuntu@LAPTOP-FSPULTNV' >> ~/.ssh/authorized_keys # pc
# 读取setupSSH.sh相同路径下的id_rsa.pub文件
cat id_rsa.pub >> ~/.ssh/authorized_keys

# 更新包列表
apt update -y > /dev/null
# 可选：恢复完整 Ubuntu 环境（耗时较长，仅 SSH 可跳过）
yes | unminimize > /dev/null
apt install -y -qq -o=Dpkg::Use-Pty=0 openssh-server > /dev/null # pwgen net-tools psmisc pciutils htop neofetch zsh nano byobu

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa # 

echo ListenAddress 127.0.0.1 >> /etc/ssh/sshd_config

mkdir -p /run/sshd
/usr/sbin/sshd

# ssh -p 22 root@127.0.0.1