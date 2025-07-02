#/bin/sh
# !sh /content/drive/MyDrive/code/colab-tricks/setupSSH.sh
mkdir -p ~/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPYailQPgSx4nSZsG9OWay9igX6eQepHXrN26VATzLYmXPpZtG7NaoMNskcg64VdCF4e8WuUUOLZNS8q8YxO+4sOr1o0WFRbWHfyqeWHH9Y446rHJubyQdDy7Yhwl/xa9ko8x86SqgpdFPs+ZgAhJV2+vIWc5TsgpnMohUg2TD8iPv16lxcNBBOSPuWixdeCIcMO43qv6ZeVqaYaHcnbiVXyPjg180M7OG9bZC8MnLXOVRqHAujFnp5HwcSyl9rfHlSRafbGcfgI1eOM+bpdW1firiDkI+TjqRnYKstsz2oRRT3JWT0FfKs3A9dodyOj1mmWhmI80PxL+mCeqdYDbH5iB4whRsb+vjr9GwCKiA/jPnnBhz2wSDiNQvPJaEh4tbGyCLvRHUTRvqjObQ1RPzfL3B84A317LsCMjB1J/wN83P5e5CGqzEAd1VAGmJg6bAQo4XIB4KEukoZxr+og7q/1am/LqmTJzSB5ZLrtZ2Q3oPk/RN7g5wH+o/YqVEU7x1GF/Ltm6wXWirfscOP375nbfAn+mJfSbSertCfCAVe5H73Y3r1XgZpIfF3aTgQfSAolroL+5k6jFbb3uOEzeHPZFTI8CQZvWLraI4n/OpEMlH5tyP2DHUzN9FXR2As+wEcUIVpfzEwiVD1caUkI0oJORVPOHEZng/YFcrjraS2w== dingchao1007@gmail.com' >> ~/.ssh/authorized_keys # pc

echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyRzwoU+piy0G0agOmioqIga/BDhZm13R0Ee3/UwRPsVWwzzZdynPbuar0Vw1o6K9f3FMroyENjaTwsg/XsRV+0FdLsFQsDZsEyB0KmVt5sGBi7haJl/0edf0obEz9ZHjwMBSawQeIHdMFgr2JKwwN6/qLgkUtrwCGATK/SlNRjVPk/APcp9AXv89LJPxozRlertZgowkYtmAW6BCF0Pk3HFO3wYNkFmjxfTv3/6UoR7O3p40YYDmajsTKnvcgLoWAR8KKvFjqgcGZrwIpI1gMv+gqL2OHGzuFXMjnxVq+pHBoL49X2DPXh1RhLuPt1FwBEbpaNwkWvVw9NM3OyvcF root@f7b5c8b00264b011ed08d31013ec31c5290f-task1-0' >> ~/.ssh/authorized_keys # openi
# apt-get update -y
yes | unminimize
apt-get install -y -qq -o=Dpkg::Use-Pty=0 openssh-server pwgen net-tools psmisc pciutils htop neofetch zsh nano byobu

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

echo ListenAddress 127.0.0.1 >> /etc/ssh/sshd_config

mkdir -p /var/run/sshd
/usr/sbin/sshd
