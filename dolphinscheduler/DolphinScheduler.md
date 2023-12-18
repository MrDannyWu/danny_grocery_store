### Install

下载
```shell
ssh snn wget -P /usr/local/ https://dlcdn.apache.org/dolphinscheduler/3.1.7/apache-dolphinscheduler-3.1.7-bin.tar.gz --no-check-certificate
```

### nn
```shell
cd /usr/local
scp snn:/usr/local/apache-dolphinscheduler-3.1.7-bin.tar.gz ./
tar -zxvf /usr/local/apache-dolphinscheduler-3.1.7-bin.tar.gz -C /usr/local
mv apache-dolphinscheduler-3.1.7-bin apache-dolphinscheduler-3.1.7
```

## 配置
```shell
#在 /usr/local/apache-dolphinscheduler-3.1.7/bin/env/dolphinscheduler_env.sh 做一些配置修改
vim /usr/local/apache-dolphinscheduler-3.1.7/bin/env/dolphinscheduler_env.sh

# 修改 java 环境变量
export JAVA_HOME=${JAVA_HOME:-/usr/java/jdk1.8.0_172-amd64}

# 修改或增加DolphinScheduler元数据的数据源配置，替换为MySQL存储
export DATABASE=${DATABASE:-mysql}
export SPRING_PROFILES_ACTIVE=${DATABASE}
export SPRING_DATASOURCE_URL="jdbc:mysql://host:3306/dolphinscheduler?useUnicode=true&characterEncoding=UTF-8&useSSL=false"
export SPRING_DATASOURCE_USERNAME="username"
export SPRING_DATASOURCE_PASSWORD="password"

# 记得初始化元数据，以及需要升级要执行升级的sql,升级的sql对应在 /usr/local/apache-dolphinscheduler-3.1.7/standalone-server/conf/sql/upgrade 下面
/usr/local/apache-dolphinscheduler-3.1.7/standalone-server/conf/sql/dolphinscheduler_mysql.sql

# 根据需求修改下面的配置
export HADOOP_HOME=${HADOOP_HOME:-/opt/cloudera/parcels/CDH/lib/hadoop}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-/etc/hadoop/conf}
export SPARK_HOME1=${SPARK_HOME1:-/opt/soft/spark1}
export SPARK_HOME2=${SPARK_HOME2:-/opt/soft/spark2}
export PYTHON_HOME=${PYTHON_HOME:-/opt/soft/python}
export HIVE_HOME=${HIVE_HOME:-/usr/local/apache-hive-3.1.3-bin/}
export FLINK_HOME=${FLINK_HOME:-/usr/local/flink-1.17.1/}
export DATAX_HOME=${DATAX_HOME:-/opt/soft/datax}
export SEATUNNEL_HOME=${SEATUNNEL_HOME:-/opt/soft/seatunnel}
export CHUNJUN_HOME=${CHUNJUN_HOME:-/opt/soft/chunjun}

# 替换/usr/local/apache-dolphinscheduler-3.1.7/standalone-server/conf 下的 dolphinscheduler_env.sh
rm /usr/local/apache-dolphinscheduler-3.1.7/standalone-server/conf/dolphinscheduler_env.sh
cp /usr/local/apache-dolphinscheduler-3.1.7/bin/env/dolphinscheduler_env.sh /usr/local/apache-dolphinscheduler-3.1.7/standalone-server/conf/

# 注释掉 /usr/local/apache-dolphinscheduler-3.1.7/standalone-server/bin/start.sh
# export DATABASE=${DATABASE:-h2}
# 或改为 
export DATABASE=${DATABASE:-mysql}

# 添加需要的 mysql-connect jar 包到 
cp /usr/local/apache-dolphinscheduler-dev/api-server/libs/mysql-connector-java-8.0.15.jar /usr/local/apache-dolphinscheduler-3.1.7/api-server/libs/mysql-connector-java-8.0.15.jar
cp /usr/local/apache-dolphinscheduler-dev/api-server/libs/mysql-connector-java-8.0.15.jar /usr/local/apache-dolphinscheduler-3.1.7/standalone-server/libs/standalone-server/mysql-connector-java-8.0.15.jar
cp /usr/local/apache-dolphinscheduler-dev/api-server/libs/mysql-connector-java-8.0.15.jar /usr/local/apache-dolphinscheduler-3.1.7/alert-server/libs/mysql-connector-java-8.0.15.jar
cp /usr/local/apache-dolphinscheduler-dev/api-server/libs/mysql-connector-java-8.0.15.jar /usr/local/apache-dolphinscheduler-3.1.7/worker-server/libs/mysql-connector-java-8.0.15.jar
cp /usr/local/apache-dolphinscheduler-dev/api-server/libs/mysql-connector-java-8.0.15.jar /usr/local/apache-dolphinscheduler-3.1.7/tools/libs/mysql-connector-java-8.0.15.jar
cp /usr/local/apache-dolphinscheduler-dev/api-server/libs/mysql-connector-java-8.0.15.jar /usr/local/apache-dolphinscheduler-3.1.7/master-server/libs/mysql-connector-java-8.0.15.jar

```

### 启动、关闭
```shell
cd /usr/local/cd apache-dolphinscheduler-3.1.7
bash ./bin/dolphinscheduler-daemon.sh start standalone-server
bash ./bin/dolphinscheduler-daemon.sh stop standalone-server
```

## Web 管理
```shell
http://nn:12345/dolphinscheduler/ui/home
admin/admin
```