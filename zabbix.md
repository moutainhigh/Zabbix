# zabbix 3.2
## 1.部署Server
### 1.1环境依赖 
```
##1. LNMP环境
##2. yum install gcc gcc-c++ libxml2 libxml2-devel  net-snmp net-snmp-deve libcurl libcurl-devel   -y  
```
### 1.2新建用户
```
groupadd -g 502 zabbix
useradd -g 502 -u 502 zabbix
```
### 1.3 获取源码
```
wget https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/3.2.1/zabbix-3.2.1.tar.gz/download --no-check-certificate
```
### 1.4 安装
```
##1.解压
tar fvx zabbix-3.2.1.tar.gz
##2.编译
./configure \
--prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql  --with-net-snmp --with-libcurl 
##3.安装
make && make install
```
### 1.5zabbix数据
```
##1.创建库
mysql>create database zabbix character set utf8;
mysql>grant all on zabbix.* to zabbix@localhost identified by 'redhat';
##2.导入表
pwd: /usr/local/src/zabbix-3.2.1/database/mysql/
mysql -uzabbix -predhat zabbix < schema.sql 
mysql -uzabbix -predhat zabbix  < images.sql 
mysql -uzabbix -predhat zabbix  < data.sql 
```

### 1.6 配置文件
```
pw:/usr/local/zabbix/etc/zabbix_server.conf
##1.日志位置,根据需求修改;
LogFile=/tmp/zabbix_server.log
##PID 所在位置;
PidFile=/tmp/zabbix_server.pid
##mysql主机地址;
DBHost=localhost
##数据库名称;
DBName=zabbix
##数据库用户名
DBUser=zabbix
##数据库密码
DBPassword=redhat  
```
### 1.7启动脚本
```
##1.添加脚本
cp /usr/local/src/zabbix-3.2.1/misc/init.d/fedora/core/zabbix_server /etc/init.d 
chmod +x /etc/init.d/zabbix_server
##2.编辑脚本
*修改这个,zabbix 的安装目录
BASEDIR=/usr/local/zabbix 
*添加这一行,定义配置文件位置
CONFILE=$BASEDIR/etc/zabbix_server.conf 
*搜索 start,修改启动选项,默认是去/etc 下去找配置文件的
action $"Starting $BINARY_NAME: " $FULLPATH -c $CONFILE 
```
### 1.8Web界面
```
nginx_dir：/data/web/zabbix
zabbix_dir:/usr/local/src/zabbix-3.2.1/frontends/php
cp -rf zabbix_dir nginx_dir
##用浏览器打开zabbix,根据提示修改php即可
```

## 2.部署Agent
### 2.1获取源码
```
wget http://www.zabbix.com/downloads/3.2.0zabbix_agents_3.2.0.linux2_6.amd64.tar.gz
```
### 2.2安装
```
mkdir /usr/local/zabbix_agent
tar fvx abbix_agents_3.2.0.linux2_6.amd64.tar.gz -C zabbix_agent
```
### 配置文件
```
pwd:conf/zabbix_agentd.conf
##1.日志
LogFile=/tmp/zabbix_agentd.log
##2.Server IP
Server= 
##3.Server IP(主动模式)
ServerActive=
##4Agent IP(不要写127.0.0.1)
Hostname=202.108.1.51
``` 
### 2.3启动脚本
```
##1.脚本在Server服务器解压的源码目录
pw：misc/init.d/fedora/core/zabbix_agentd

##2.编辑脚本(视情况而定)
*修改这个,zabbix_agent的安装目录
BASEDIR=/usr/local/zabbix  
*添加这一行,定义配置文件位置
CONFILE=$BASEDIR/etc/zabbix_agentd.conf
*搜索 start 添加 "-c $CONFILE"
 action $"Starting $BINARY_NAME: " $FULLPATH -c $CONFILE 
```