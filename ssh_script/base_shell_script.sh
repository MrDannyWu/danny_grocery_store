# 生成私钥, 公钥
ssh-keygen -t rsa

# 免密登录
# 如果想让 B 免密登录到 A
A> ssh-copy-id <B>

# 查看系统信息
uname -a

# 查看Linux发行版本信息
sudo apt-get install lsb-core -y
lsb_release -a
uname -a
uname -v

# 添加用户
adduser <username>

# 删除用户
deluser <username>

# 查询端口是否被占用
netstat -anp | grep <port>

firewall-cmd --state                           ##查看防火墙状态，是否是running
firewall-cmd --reload                          ##重新载入配置，比如添加规则之后，需要执行此命令
firewall-cmd --get-zones                       ##列出支持的zone
firewall-cmd --get-services                    ##列出支持的服务，在列表中的服务是放行的
firewall-cmd --query-service ftp               ##查看ftp服务是否支持，返回yes或者no
firewall-cmd --add-service=ftp                 ##临时开放ftp服务
firewall-cmd --add-service=ftp --permanent     ##永久开放ftp服务
firewall-cmd --remove-service=ftp --permanent  ##永久移除ftp服务
firewall-cmd --add-port=80/tcp --permanent     ##永久添加80端口
iptables -L -n                                 ##查看规则，这个命令是和iptables的相同的
man firewall-cmd                               ##查看帮助
systemctl status firewalld.service                               ##查看防火墙状态
systemctl [start|stop|restart] firewalld.service                 ##启动|关闭|重新启动  防火墙

##查询端口号80 是否开启
firewall-cmd --query-port=80/tcp

# 查找文件
find
whereis
