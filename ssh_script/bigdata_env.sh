# Configure bigdata cluster base environment variables
export JAVA_HOME=/usr/java/jdk1.8.0_181-cloudera
export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib
export HIVE_HOME=/usr/local/apache-hive-3.1.3-bin
export FLINK_HOME=/usr/local/flink-1.17.1
export YARN_CONF_DIR=/etc/hadoop/conf
export YARN_HOME=/opt/cloudera/parcels/CDH/lib/hadoop-yarn
export HBASE_CONF_DIR=/etc/hbase/conf
export HADOOP_CONF_DIR=/etc/hadoop/conf
export HADOOP_HOME=/opt/cloudera/parcels/CDH/lib/hadoop
export HADOOP_CLASSPATH=`hadoop classpath`
export HADOOP_COMMON_HOME=/opt/cloudera/parcels/CDH/lib/hadoop
export HADOOP_HDFS_HOME=/opt/cloudera/parcels/CDH/lib/hadoop-hdfs
export HADOOP_MAPRED_HOME=/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce
export CLASSPATH=.:$CLASSPATH:`$HADOOP_HDFS_HOME/bin/hdfs classpath --glob`
export PATH=$JAVA_HOME/bin:$FLINK_HOME/bin/:$HIVE_HOME/bin:$HADOOP_HOME/bin:$YARN_HOME/bin:$PATH