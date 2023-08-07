## 一、准备
官网 https://trino.io/
1. Trino 419 安装包（https://repo1.maven.org/maven2/io/trino/trino-server/419/trino-server-419.tar.gz）可以从 https://trino.io/docs/current/installation/deployment.html 找到
2. JDK 17
3. python  2.6.x, 2.7.x, or 3.x

## 二、安装 JDK 17
```shell
cd /usr/local
mkdir java
cd java
wget https://download.oracle.com/java/17/archive/jdk-17.0.6_linux-x64_bin.tar.gz
tar -zxvf jdk-17.0.6_linux-x64_bin.tar.gz
```

## 三、 安装 Trino
```shell
cd /usr/local
wget https://repo1.maven.org/maven2/io/trino/trino-server/419/trino-server-419.tar.gz
tar -zxvf trino-server-419.tar.gz
cd trino-server-419/bin

vim launcher 
# 在 exec "$(dirname "$0")/launcher.py" "$@" 上面添加 PATH=/usr/local/java/jdk-17.0.6/bin/:$PATH
# 即：
    PATH=/usr/local/java/jdk-17.0.6/bin/:$PATH
    exec "$(dirname "$0")/launcher.py" "$@"

```

## 四、 配置 Trino jvm.config
```shell
cd cd /usr/local/trino-server-419
mkdir ./etc
vim jvm.config

# 填入以下内容
-server
-Xmx4G
-XX:InitialRAMPercentage=80
-XX:MaxRAMPercentage=80
-XX:G1HeapRegionSize=32M
-XX:+ExplicitGCInvokesConcurrent
-XX:+ExitOnOutOfMemoryError
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-XX:ReservedCodeCacheSize=512M
-XX:PerMethodRecompilationCutoff=10000
-XX:PerBytecodeRecompilationCutoff=10000
-Djdk.attach.allowAttachSelf=true
-Djdk.nio.maxCachedBufferSize=2000000
-XX:+UnlockDiagnosticVMOptions
-XX:+UseAESCTRIntrinsics
# Disable Preventive GC for performance reasons (JDK-8293861)
-XX:-G1UsePreventiveGC
```

## 五、 配置 Trino node.properties
```shell
cd cd /usr/local/trino-server-419/etc
vim node.properties

# 填入以下内容
node.environment=production
node.id=67d8c4ab-191d-46c4-afb3-f657daab2493
node.data-dir=/var/trino/data

# 注： 
    1. 集群所有的 environment 值为一样
    2. 每个节点的id要不一样

```

## 六、 配置 Trino config.properties
```shell
cd cd /usr/local/trino-server-419/etc
vim config.properties

# 填入以下内容
1. 以下是coordinator的最小配置：
coordinator=true
node-scheduler.include-coordinator=false
http-server.http.port=8086
discovery.uri=http://nn-1:8086

2. 这是workers的最低配置：
coordinator=false
http-server.http.port=8086
discovery.uri=http://nn-1:8086

3. 或者，如果您要设置一台机器进行测试，同时充当coordinator和workers，请使用此配置：
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=8086
discovery.uri=http://nn-1:8086

# 注：discovery.uri 都和 coordinator 一样

```

## 七、 配置 Trino log.properties
```shell
cd cd /usr/local/trino-server-419/etc
vim log.properties

# 填入以下内容
io.trino=INFO

可取值：DEBUG, INFO, WARN, ERROR
```

## catalog 配置, 以iceberg为例
```shell
cd /usr/local/trino-server-419/etc

mkdir catalog

vim iceberg.properties

# 填入一下内容
connector.name=iceberg
iceberg.file-format=PARQUET
iceberg.catalog.type=HIVE_METASTORE
hive.metastore.uri=thrift://nn-2:9083,thrift://nn-1:9083
hive.config.resources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml

```

## 九、 启动及使用
```shell
cd /usr/local/trino-server-419/bin
./launcher start # 启动服务
./launcher run # Starts the server in the foreground and leaves it running. To shut down the server, use Ctrl+C in this terminal or the stop command from another terminal.
./launcher stop # 关闭服务

jdbc 链接：
trino://admin@nn-1:8086/iceberg
```

## 十、性能优化
```shell
1. 增加 worker 节点数。
2. 增加内存配置。

```

## 十一、升级  
已设置免密的集群上，在主节点执行
```shell
#!/bin/sh
# auto upgrade trino version (centos version)
# for example: ./upgrade.sh 419 422
echo "old version $1 upgrade to new version $2 !"
exch "Start download trino-server-$2.tar.gz !"
wget -P /usr/local/ https://repo1.maven.org/maven2/io/trino/trino-server/$2/trino-server-$2.tar.gz
exch "trino-server-$2.tar.gz download complete !"

echo "Upgrading..."
cd /usr/local
tar -zxvf /usr/local/trino-server-$2.tar.gz -C /usr/local

cd /usr/local/trino-server-$2/bin
rm -f ./launcher
cp ../../trino-server-$1/bin/launcher .

xsync.sh /usr/local/trino-server-$2/

xcall.sh cp -r /usr/local/trino-server-$1/etc/ /usr/local/trino-server-$2/
xcall.sh cp -r /usr/local/trino-server-$1/plugin/paimon /usr/local/trino-server-$2/plugin/

xcall.sh /usr/local/trino-server-$1/bin/launcher stop
xcall.sh /usr/local/trino-server-$2/bin/launcher start

echo "Upgrade trino finished !"
```