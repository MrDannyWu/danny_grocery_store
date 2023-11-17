#!/bin/bash
# bath_ssh_no_pass_login.sh
# generate /opt/ip_list.txt for bath_ssh_no_pass_login.sh
# cat /opt/ip_list.txt
# 192.168.1.100
# 192.168.1.101
# 192.168.1.102

# usage
# bath_ssh_no_pass_login.sh [password]

yum install expect -y
IPS=/opt/ip_list.txt
PASSWD=$1

if [ ! -n "$PASSWD" ]; then
  PASSWD=123456
fi

# ssh-keygen
for IP in $(cat $IPS)
  do
/usr/bin/expect << EOF
    spawn ssh $IP "rm -rf  /root/.ssh; echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config; ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa -q"
    expect {
        "yes/no" { send "yes\n";exp_continue }
        "password" { send "$PASSWD\n" }
    }
    expect "*password*" {send "$PASSWD\n";}
    expect eof
EOF
  done

# copy id_rsa.pub
for IP in $(cat $IPS)
  do
/usr/bin/expect << EOF
    spawn scp root@$IP:/root/.ssh/id_rsa.pub /root/.ssh/id_rsa.pub.$IP
    expect {
        "yes/no" { send "yes\n";exp_continue }
        "password" { send "$PASSWD\n" }
    }
    expect "*password*" {send "$PASSWD\n"}
    expect eof
EOF
    cat /root/.ssh/id_rsa.pub.$IP >> /root/.ssh/authorized_keys
    rm -f /root/.ssh/id_rsa.pub.$IP
  done

## push authorized_keys
for COREIP in $(cat $IPS | sed -n '2,$p')
  do
/usr/bin/expect << EOF
    spawn scp /root/.ssh/authorized_keys root@$COREIP:/root/.ssh/authorized_keys
    expect {
        "yes/no" { send "yes\n";exp_continue }
        "password" { send "$PASSWD\n" }
    }
    expect "*password*" {send "$PASSWD\n"}
    expect eof
EOF
  done