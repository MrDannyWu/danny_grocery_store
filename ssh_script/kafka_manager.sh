#! /bin/bash

hosts="hadoop102 hadoop103 hadoop104"
case $1 in
"start"){
    for i in $hosts
    do
        echo " --------Starting $i Kafka-------"
        ssh $i "/opt/module/kafka/bin/kafka-server-start.sh -daemon /opt/module/kafka/config/server.properties"
    done
};;
"stop"){
    for i in $hosts
    do
        echo " --------Stopping $i Kafka-------"
        ssh $i "/opt/module/kafka/bin/kafka-server-stop.sh stop"
    done
};;
esac
