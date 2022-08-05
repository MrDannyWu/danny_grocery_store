#!/bin/bash

hosts="hadoop102 hadoop103 hadoop104"
zk_version="3.5.7"
case $1 in
"start"){
	for i in $hosts
	do
        echo ---------- zookeeper $i Start ------------
		ssh $i "/opt/module/zookeeper-$zk_version/bin/zkServer.sh start"
	done
};;
"stop"){
	for i in $hosts
	do
        echo ---------- zookeeper $i Stop ------------
		ssh $i "/opt/module/zookeeper-$zk_version/bin/zkServer.sh stop"
	done
};;
"status"){
	for i in $hosts
	do
        echo ---------- zookeeper $i Status ------------
		ssh $i "/opt/module/zookeeper-$zk_version/bin/zkServer.sh status"
	done
};;
esac
