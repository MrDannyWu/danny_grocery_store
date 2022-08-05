#! /bin/bash
# 查看进程脚本
hosts="hadoop102 hadoop103 hadoop104"
for i in hosts
do
    echo --------- $i ----------
    ssh $i "$*"
done
