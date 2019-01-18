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

apt-get install gcc automake autoconf libtool make screen -y

wget http://www.rarlab.com/rar/rarlinux-x64-5.3.0.tar.gz
tar -zxvf rarlinux-x64-5.3.0.tar.gz
cd rar
make

cd /home

wget http://appdown.rrys.tv/rrshareweb_linux.rar
unrar x rrshareweb_linux.rar
tar -zxvf rrshareweb_centos7.tar.gz

cat >> /etc/rc.local << "EOF"
#!/bin/sh -e
nohup /home/rrshareweb/rrshareweb &
exit 0
EOF

chmod +x /etc/rc.local 
systemctl start rc-local

mkdir -p /opt/work/store

reboot
