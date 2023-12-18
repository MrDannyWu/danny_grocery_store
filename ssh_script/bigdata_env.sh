# Configure bigdata cluster base environment variables
export JAVA_HOME=/usr/java/jdk1.8.0_181-cloudera
export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib
export HIVE_HOME=/usr/local/apache-hive-3.1.3-bin
export FLINK_HOME=/usr/local/flink-1.17.1
export HADOOP_CONF_DIR=/etc/hadoop/conf
export YARN_CONF_DIR=/etc/hadoop/conf
export HADOOP_HOME=/opt/cloudera/parcels/CDH/lib/hadoop
export HADOOP_CLASSPATH=`hadoop classpath`
export HBASE_CONF_DIR=/etc/hbase/conf
export PATH=$JAVA_HOME/bin:$FLINK_HOME/bin/:$HIVE_HOME/bin:$PATH