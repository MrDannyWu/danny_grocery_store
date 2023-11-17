#!/bin/bash
# bath_modify_cluster_hosts.sh
# generate /opt/ip_host_list.txt for bath_ssh_no_pass_login.sh
# cat /opt/ip_host_list.txt
# 192.168.1.100 hadoop1 hadoop1
# 192.168.1.101 hadoop2 hadoop2
# 192.168.1.102 hadoop3 hadoop3

# usage
# ./bath_ssh_no_pass_login.sh

IHL=/opt/ip_host_list.txt
echo "127.0.0.1 localhost.localdomain localhost localhost4.localdomain4 localhost4" > /etc/hosts
echo "::1 localhost.localdomain localhost localhost6.localdomain6 localhost6" >> /etc/hosts

cat $IHL | while read line
  do
    echo $line >> /etc/hosts
  done

/usr/bin/xsync /etc/hosts