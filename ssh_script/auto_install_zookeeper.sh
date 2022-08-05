#! /bin/bash
#注意将当中所涉及的机器别名(一共有三个地方需修改)修改成自己的机器别名
hosts="node100 node101 node102"
path="/opt/zookeeper"
zk_version="3.5.7"
if [ ! -d $path ]
then
   mkdir $path
fi
cd $path
mkdir zkdata
mkdir zkdatalog
if [ ! -f zookeeper-$zk_version.tar.gz ]
then
   wget http://archive.apache.org/dist/zookeeper/zookeeper-$zk_version/zookeeper-$zk_version.tar.gz
fi
tar -zxvf zookeeper-$zk_version.tar.gz
cd /opt/zookeeper/zookeeper-$zk_version/conf
cp zoo_sample.cfg zoo.cfg
cat >zoo.cfg<<EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/opt/zookeeper/zkdata
dataLogDir=/opt/zookeeper/zkdatalog
clientPort=12181
server.1=node100:12888:13888
server.2=node101:12888:13888
server.3=node102:12888:13888
#server.1 这个1是服务器的标识也可以是其他的数字， 表示这个是第几号服务器，用来标识服务器，这个标识要写到快照目录下面myid文件里
#192.168.7.107为集群里的IP地址，第一个端口是master和slave之间的通信端口，默认是2888，第二个端口是leader选举的端口，集群刚启动的时候选举或者leader挂掉之后进行新的选举的端口默认是3888
EOF
i=1
for host in $hosts
do
   echo "$i" > /opt/zookeeper/zkdata/myid
   if [ $host != "node100" ]
   then
      scp -r /opt/zookeeper @$host:/opt
   fi
   echo "1" > /opt/zookeeper/zkdata/myid
   i=`expr $i + 1`;
done
echo "Finished !"