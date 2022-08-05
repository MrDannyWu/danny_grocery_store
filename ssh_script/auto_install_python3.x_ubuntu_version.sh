#!/bin/sh
# auto install python3.x (ubuntu version)
# for example: ./auto_install_python3.x_ubuntu_version.sh 3.8.7

# 安装依赖
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install build-essential python-dev python-setuptools python-pip python-smbus -y
sudo apt-get install build-essential libncursesw5-dev libgdbm-dev libc6-dev -y
sudo apt-get install zlib1g-dev libsqlite3-dev tk-dev -y
sudo apt-get install libssl-dev openssl -y
sudo apt-get install libffi-dev -y

# 下载、编译、安装python3
wget https://www.python.org/ftp/python/$1/Python-$1.tgz
tar -zxvf Python-$1.tgz
cd Python-$1
./configure --prefix=/usr/local/python3
make && make install
mv /usr/bin/python3 /usr/bin/python3.bak
mv /usr/bin/pip3 /usr/bin/pip3.bak
ln -s /usr/local/python3/bin/python3 /usr/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
echo "Finished !"