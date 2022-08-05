#!/bin/sh
# auto install python3.x (centos version)
# for example: ./auto_install_python3.x_centos_version.sh 3.8.7

# 安装依赖
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel

# 下载、编译、安装python3
wget https://www.python.org/ftp/python/$1/Python-$1.tgz
tar -zxvf Python-$1.tgz
mkdir /usr/local/python3
cd Python-$1
./configure --prefix=/usr/local/python3
make && make install
[ -f /usr/bin/python3 ] && mv /usr/bin/python3 /usr/bin/python3_bak
[ -f /usr/bin/pip3 ] && mv /usr/bin/pip3  /usr/bin/pip3_bak
ln -s /usr/local/python3/bin/python3 /usr/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
echo "Finished !"