#!/bin/sh
# auto install python3.x (centos version)
# for example: ./auto_install_python3.x_centos_version.sh 3.8.7

# Install dependencies
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel

# For Python3.10 or above, a higher version of openssl needs to be installed
yum install -y epel-release.noarch
yum install -y openssl11 openssl11-devel

# Download, compile and install Python3.x
wget https://www.python.org/ftp/python/$1/Python-$1.tgz
tar -zxvf Python-$1.tgz
mkdir /usr/local/python3
cd Python-$1

# For Python 3.10 or above replace openssl with openssl11.
sed -i 's/PKG_CONFIG openssl /PKG_CONFIG openssl11 /g' configure

./configure --prefix=/usr/local/python3
make && make install

[ -f /usr/bin/python3 ] && mv /usr/bin/python3 /usr/bin/python3_bak
[ -f /usr/bin/pip3 ] && mv /usr/bin/pip3  /usr/bin/pip3_bak
ln -s /usr/local/python3/bin/python3 /usr/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
echo "Finished !"