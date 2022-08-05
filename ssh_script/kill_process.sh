#! /bin/bash
# example: kill all python3 process: ./kill_process.sh python3
ps -ef | grep $1 | grep -v grep | awk '{print $2}' | xargs echo | xargs kill -9
echo "Finished !"