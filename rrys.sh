#!/usr/bin/env bash
#
# Auto install RRYS
#
# System Required:  debian9
#
# Copyright (C)  2019 xxhjkl
#
# URL: http://www.xxhjkl.me/?p=404
#

apt-get update
apt-get install gcc automake autoconf libtool make screen curl -y

# 提高文件打开数

sed -i '/^fs.file-max.*/'d /etc/sysctl.conf
sed -i '/^fs.nr_open.*/'d /etc/sysctl.conf
echo "fs.file-max = 1048576" >> /etc/sysctl.conf
echo "fs.nr_open = 1048576" >> /etc/sysctl.conf

sed -i '/.*nofile.*/'d /etc/security/limits.conf
sed -i '/.*nproc.*/'d /etc/security/limits.conf

cat>>/etc/security/limits.conf<<EOF
* - nofile 1048575
* - nproc 1048575
root soft nofile 1048574
root hard nofile 1048574
$ANUSER hard nofile 1048573
$ANUSER soft nofile 1048573
EOF

sed -i '/^DefaultLimitNOFILE.*/'d /etc/systemd/system.conf
sed -i '/^DefaultLimitNPROC.*/'d /etc/systemd/system.conf
echo "DefaultLimitNOFILE=999998" >> /etc/systemd/system.conf
echo "DefaultLimitNPROC=999998" >> /etc/systemd/system.conf

# 开启bbr
modprobe tcp_bbr
echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p


# 安装人人影视客户端
wget http://appdown.rrysapp.com/rrshareweb_centos7.tar.gz
tar -zxvf rrshareweb_centos7.tar.gz

# 建立服务 systemctl (start/stop/status/restart) renren
cat > /etc/systemd/system/renren.service <<EOF
[Unit]
Description=RenRen server
After=network.target
Wants=network.target

[Service]
Type=simple
PIDFile=/var/run/renren.pid
ExecStart=/home/rrshareweb/rrshareweb
RestartPreventExitStatus=23
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# 创建开机启动脚本
cat >> /etc/rc.local << "EOF"
#!/bin/sh -e
systemctl start renren
exit 0
EOF

chmod +x /etc/rc.local 
systemctl start rc-local

nohup /home/rrshareweb/rrshareweb &
# 检查是否开启bbr
lsmod | grep bbr
