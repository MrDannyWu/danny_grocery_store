#! /bin/bash
. /etc/profile
. ~/.bash_profile
date -R
trino_pid=$(ps -ef |grep local/trino-server |grep -v grep | awk '{print $2}')
# echo $trino_pid
if [ $trino_pid > 0 ];then
    echo 'trino running'
    /usr/local/jdk/bin/jps |grep Trino
else
    echo 'trino closed'
    rm -f /var/trino/data/java_pid*.hprof
    echo 'already deleted /var/trino/data/java_pid*.hprof'
    export JAVAHOME=/usr/local/jdk
    /usr/local/trino-server-430/bin/launcher restart
fi
