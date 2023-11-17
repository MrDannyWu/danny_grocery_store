### 配置
```shell
root 123456
```

### 编写 xsync xcall 脚本
```shell
# /usr/bin/xcall 内容

#! /bin/bash
# cluster command execution
# xcall [command]

IPS=/opt/ip_list.txt
for i in $(cat $IPS)
do
    echo --------- $i ----------
    ssh $i "$*"
done

# /usr/bin/xsync 内容

#!/bin/bash
# cluster file distribution
# xsync [file or dir]

IPS=/opt/ip_list.txt
if [ $# -lt 1 ]
then
  echo Not Enough Arguement!
  exit;
fi

for host in $(cat $IPS)
do
  echo ====================  $host  ====================
  for file in $@
  do
    if [ -e $file ]
    then
      pdir=$(cd -P $(dirname $file); pwd)
      f_name=$(basename $file)
      ssh $host "mkdir -p $pdir"
      rsync -av $pdir/$f_name $host:$pdir
    else
      echo $file does not exists!
    fi
  done
done

chmod +x /usr/bin/xcall /usr/bin/xsync
```

### 修改 所有 hosts
```shell
127.0.0.1 localhost.localdomain localhost localhost4.localdomain4 localhost4
::1 localhost.localdomain localhost localhost6.localdomain6 localhost6

10.206.0.9  hadoop5 hadoop5
10.206.0.16 hadoop6 hadoop6
10.206.0.6  hadoop7 hadoop7
10.206.0.13 hadoop8 hadoop8
10.206.0.2  hadoop9 hadoop9

# 将上述 hosts 内容更新到所有机器 /etc/hosts

```

### 设置所有机器免密登录，每台机器都进行一下操作
```shell
ssh-keygen -t rsa
# 上面执行时一直回车即可
ssh-copy-id hadoop5
ssh-copy-id hadoop6
ssh-copy-id hadoop7
ssh-copy-id hadoop8
ssh-copy-id hadoop9

```

### 安装 jdk (所有机器都要安装)
```shell
rpm -ivh oracle-j2sdk1.8-1.8.0+update181-1.x86_64.rpm

vim /etc/profile.d/my_env.sh
export JAVA_HOME=/usr/java/jdk1.8.0_181-cloudera
export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib
export PATH=$PATH:$JAVA_HOME/bin

source /etc/profile.d/my_env.sh
java -version

# 分发
xsync /usr/java
xsync /etc/profile.d/my_env.sh

# 其他每台机器都要执行
source /etc/profile.d/my_env.sh

# 验证
xcall jps

```

### 在 cm 节点（此处是 hadoop5）安装 MySQL
```shell
# 卸载已有的数据库
rpm -e --nodeps mysql-libs-5.1.73-7.el6.x86_64

# 删除已有的依赖
yum remove mysql-libs

# 下载并安装 MySQL 依赖
yum install libaio
yum -y install autoconf
wget https://downloads.mysql.com/archives/get/p/23/file/MySQL-shared-compat-5.6.24-1.el6.x86_64.rpm
wget https://downloads.mysql.com/archives/get/p/23/file/MySQL-shared-5.6.24-1.el6.x86_64.rpm
rpm -ivh MySQL-shared-5.6.24-1.el6.x86_64.rpm
rpm -ivh MySQL-shared-compat-5.6.24-1.el6.x86_64.rpm

# mysql server,client 安装包
wget https://downloads.mysql.com/archives/get/p/23/file/MySQL-client-5.6.24-1.el6.x86_64.rpm
wget https://downloads.mysql.com/archives/get/p/23/file/MySQL-server-5.6.24-1.el6.x86_64.rpm

# 安装 MySQL server
rpm -ivh MySQL-server-5.6.24-1.el6.x86_64.rpm

# 查询随机密码
cat /root/.mysql_secret
# Jg36lAaf1gaoy9vX

# 查看状态并启动 MySQL
service mysql status
service mysql start


# 安装 MySQL client
rpm -ivh MySQL-client-5.6.24-1.el6.x86_64.rpm

# 连接 MySQL
mysql -uroot -p

# 修改密码
SET PASSWORD=PASSWORD('000000');
```

### 设置 MySQL（hadoop5）
```shell
mysql -uroot -p

use mysql;
update user set host='%' where host='localhost';
delete from user where host!='%';
flush privileges;
```

# CM 安装 （hadoop5）
###  在 MySQL 中创建 cm 各个组件数据库
```shell
GRANT ALL ON scm.* TO 'scm'@'%' IDENTIFIED BY 'scm';

CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE hive DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
CREATE DATABASE oozie DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
CREATE DATABASE hue DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
CREATE DATABASE sentry DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;


```

### CM 部署 （hadoop5）
```shell
mkdir /usr/share/java
cp /opt/software/mysql-connector-java-5.1.46.jar /usr/share/java/mysql-connector-java.jar


mkdir /opt/cloudera-manager
mv /opt/software/CDH6_3_2/cm6.3.1/RPMS/x86_64/cloudera-manager-agent-6.3.1-1466458.el7.x86_64.rpm /opt/cloudera-manager/
mv /opt/software/CDH6_3_2/cm6.3.1/RPMS/x86_64/cloudera-manager-server-6.3.1-1466458.el7.x86_64.rpm /opt/cloudera-manager/
mv /opt/software/CDH6_3_2/cm6.3.1/RPMS/x86_64/cloudera-manager-daemons-6.3.1-1466458.el7.x86_64.rpm /opt/cloudera-manager/

cd /opt/cloudera-manager/

# 安装 cloudera-manager-daemons
rpm -ivh cloudera-manager-daemons-6.3.1-1466458.el7.x86_64.rpm

# 分发到其他机器
xsync /opt/cloudera-manager/
# 其他机器都要安装 cloudera-manager-daemons
xcall rpm -ivh /opt/cloudera-manager/cloudera-manager-daemons-6.3.1-1466458.el7.x86_64.rpm


# 安装 cloudera-manager-agent
xcall yum install bind-utils psmisc cyrus-sasl-plain cyrus-sasl-gssapi fuse portmap fuse-libs /lib/lsb/init-functions httpd mod_ssl openssl-devel python-psycopg2 MySQL-python libxslt -y
xcall rpm -ivh /opt/cloudera-manager/cloudera-manager-agent-6.3.1-1466458.el7.x86_64.rpm

# 安装 agent 的 server 节点
# hadoop5
vim /etc/cloudera-scm-agent/config.ini
server_host=hadoop5
# hadoop6
vim /etc/cloudera-scm-agent/config.ini
server_host=hadoop5
# hadoop7
vim /etc/cloudera-scm-agent/config.ini
server_host=hadoop5
# hadoop8
vim /etc/cloudera-scm-agent/config.ini
server_host=hadoop5
# hadoop9
vim /etc/cloudera-scm-agent/config.ini
server_host=hadoop5


# 安装 cloudera-manager-server
# hadoop5
rpm -ivh /opt/cloudera-manager/cloudera-manager-server-6.3.1-1466458.el7.x86_64.rpm


# 上传 CDH 包到 parcel-repo
mv /opt/software/CDH6_3_2/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel* /opt/cloudera/parcel-repo
mv /opt/software/CDH6_3_2/manifest.json /opt/cloudera/parcel-repo
cd /opt/cloudera/parcel-repo/
mv CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha1 CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha
```

### 修改 server 的 db.porperties (hadoop5)
```shell
vim /etc/cloudera-scm-server/db.properties
 
com.cloudera.cmf.db.type=mysql
com.cloudera.cmf.db.host=hadoop5:3306
com.cloudera.cmf.db.name=scm
com.cloudera.cmf.db.user=scm
com.cloudera.cmf.db.password=scm
com.cloudera.cmf.db.setupType=EXTERNAL
```

### 启动 server 服务 (hadoop5)
```shell
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm
systemctl start cloudera-scm-server 
tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log 
```

### 启动 agent 节点 (hadoop5)
```shell
xcall systemctl restart cloudera-scm-agent
```


### 注意事项
```shell
# 每台机器都要执行
echo never > /sys/kernel/mm/transparent_hugepage/defrag
```


# 集群扩展
```shell
10.206.0.14 hadoop10 hadoop10
10.206.0.5 hadoop11 hadoop11

10.206.0.9  hadoop5 hadoop5
10.206.0.16 hadoop6 hadoop6
10.206.0.6  hadoop7 hadoop7
10.206.0.13 hadoop8 hadoop8
10.206.0.2  hadoop9 hadoop9
```

### 修改 hosts 
```shell
127.0.0.1 localhost.localdomain localhost localhost4.localdomain4 localhost4
::1 localhost.localdomain localhost localhost6.localdomain6 localhost6

10.206.0.9  hadoop5 hadoop5
10.206.0.16 hadoop6 hadoop6
10.206.0.6  hadoop7 hadoop7
10.206.0.13 hadoop8 hadoop8
10.206.0.2  hadoop9 hadoop9
10.206.0.14 hadoop10 hadoop10
10.206.0.5 hadoop11 hadoop11

```