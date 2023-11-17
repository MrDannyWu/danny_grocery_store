# danny_grocery_store
Danny 杂货铺

## 集群批量免密登录设置
```shell
# 在 opt 下新建 ip_list.txt
vim /opt/ip_list.txt

# 内容例如：
  # 192.168.1.1
  # 192.168.1.2
  # 192.168.1.3

# 在任意一台机器执行
./bath_ssh_no_pass_login.sh [password]
```

## 集群批量修改 hosts
```shell
# 在 opt 下新建 ip_host_list.txt
vim /opt/ip_host_list.txt

# 内容例如：
  # 192.168.1.1 hadoop1 hadoop1  
  # 192.168.1.2 hadoop2 hadoop2
  # 192.168.1.3 hadoop3 hadoop3

# 在任意一台机器执行
bath_modify_cluster_hosts.sh
```
Hadoop
Hive
Flink SQL
Flink CDC
Iceberg
Trino
Presto
Airflow
Grafana
Superset
Arctic
DolphinScheduler
Prometheus
Dinky
