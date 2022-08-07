### 环境
```shell
linux os
最好 mysql 8.0
```
### 通过pip3安装
```shell
配置airflow的家目录
export airflow_home = /Users/danny/airflow
install 'apache-airflow[postgres,google]==2.3.3' --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.3.3/constraints-3.7.txt"
```

### 新建后端 MySQL 库 airflow_db
```shell
CREATE DATABASE airflow_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER DATABASE airflow SET READ_COMMITTED_SNAPSHOT ON;
```

### 修改 airflow.cfg 中数据库连接url 
```shell
默认存储在sqlite, 要想改mysql作为元数据库，则修改为下面
sql_alchemy_conn = mysql+mysqlconnector://root:123456@127.0.0.1:3306/airflow_db?charset=utf8mb4
```

### 初始化数据库
```shell
airflow db init
```

### 初始化后端数据库报错处理 
```shell
安装 mysql-connector
pip3 install mysql-connector
设置数据库
set global explicit_defaults_for_timestamp =1;
```

### 启动服务
```shell
airflow standalone
```

### 
### 补充
```shell
airflow 连接mysql5.7遇到的几个错误
MySQL5.7与MySQL8版本不同导致的密码加密方式问题
Airflow从sqlite迁移到mysql，默认的mysql密码加密方式是mysql_native_password
而mysql8默认的密码加密方式是caching_sha2_password
这个问题可通过使用mysql5.7来解决，如果一定要用mysql8，需要在my.cnf配置中就配置mysql_native_password加密方式
airflow自动创建数据库有瑕疵问题
{manager.py:560} ERROR - Add Permission to Role Error: __str__ returned non-string (type bytearray)   
TypeError: unhashable type: 'bytearray'
这两个错误,出现在Airflow 成功连接mysql，执行airflow db init ,创建用户的时候
一开始我怀疑，是数据库创建的问题，但数据库是airflow自己创建的，就感觉应该问题不在这里，折腾了很久。
包括但不限于换了几个版本的docker mysql，直连物理机mysql，甚至折腾了考虑换用PostgreSQL。
最后在一篇使用TensorFlow的纠错博文中发现有可能是数据库表中某一行的类型为utf8_bin，导致无法返回String导致，
导出数据库为sql文件后，查找发现有许多数据列都是utf8_bin类型，修改第一个表ad_view_menu的数据列name的类型为utf8_general_ci后。
错误消除
```

### 填坑
```shell
如果有以下报错
INFO  [alembic.runtime.migration] Running upgrade 849da589634d -> 2c6edca13270, Resource based permissions.
[2022-08-05 05:59:30,227] {manager.py:104} INFO - Security DB not found Creating all Models from Base
[2022-08-05 05:59:30,356] {manager.py:109} ERROR - DB Creation and initialization failed: (mysql.connector.errors.DatabaseError) 3734 (HY000): Failed to add the foreign key constraint. Missing column 'run_id' for constraint 'task_map_task_instance_fkey' in the referenced table 'task_instance'
[SQL:
CREATE TABLE task_map (
        dag_id VARCHAR(250) COLLATE utf8mb3_bin NOT NULL,
        task_id VARCHAR(250) COLLATE utf8mb3_bin NOT NULL,
        run_id VARCHAR(250) COLLATE utf8mb3_bin NOT NULL,
        map_index INTEGER NOT NULL,
        length INTEGER NOT NULL,
        `keys` JSON,
        PRIMARY KEY (dag_id, task_id, run_id, map_index),
        CONSTRAINT task_map_length_not_negative CHECK (length >= 0),
        CONSTRAINT task_map_task_instance_fkey FOREIGN KEY(dag_id, task_id, run_id, map_index) REFERENCES task_instance (dag_id, task_id, run_id, map_index) ON DELETE CASCADE
)

]
(Background on this error at: https://sqlalche.me/e/14/4xp6)

需要安装
pip3 install apache-airflow-providers-mysql==2.1.1  mysql-connector-python==8.0.26 mysqlclient==2.0.3
可以修复
```

### 配置文件目录
```shell
/root/airflow/airflow.cfg
```

### dags 默认目录
```shell
/root/airflow/dags
没有的话手动创建
mkdir /root/airflow/dags
```

### admin 初始密码在
```shell
cat /root/airflow/standalone_admin_password.txt
```

安装完成后，可以通过浏览器访问http://host:8080进入 web 管理。
![img.png](img.png)