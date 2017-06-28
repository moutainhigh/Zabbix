/etc/init.d/zabbix-agent stop
/etc/init.d/zabbix-java-gateway stop
mkdir /root/zabbix
cd /root/zabbix
wget http://mirrors.aliyun.com/zabbix/zabbix/3.0/rhel/6/x86_64/zabbix-agent-3.0.3-1.el6.x86_64.rpm
wget http://mirrors.aliyun.com/zabbix/zabbix/3.0/rhel/6/x86_64/zabbix-java-gateway-3.0.3-1.el6.x86_64.rpm
yum localinstall zabbix-*  -y


wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo


将zabbix用户加入 sudo
#Defaults	requiretty
zabbix	ALL=(ALL) NOPASSWD:/usr/bin/socat


############################# Nginx ############################# 
启用nginx_status配置
在默认主机里面加上location或者你希望能访问到的主机里面。

server {
    listen  *:80 default_server;
    server_name _;
    location /nginx_status 
    {
        stub_status on;
        access_log off;
        #allow 127.0.0.1;
        #deny all;
    }
}

重启nginx

打开status页面
返回如下信息证明nginx监控状态配置成功
curl http://127.0.0.1/nginx_status
Active connections: 1 
server accepts handled requests
 1 1 1 
Reading: 0 Writing: 1 Waiting: 0 

监控php-fpm
修改php-fpm.conf配置文件
pm.status_path = /status
修改nginx.conf配置文件
        location ~ ^/(status|ping)$
    {
        include fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
    }




############################# MySQL ############################# 
下载percona监控模板
 wget https://www.percona.com/downloads/percona-monitoring-plugins/1.1.6/percona-zabbix-templates-1.1.6-1.noarch.rpm

 模板位置
 Templates are installed to /var/lib/zabbix/percona/templates

 安装脚本所需的依赖包
 yum install php php-mysql -y
 
 修改ss_get_mysql_stats.php中监控所需的账号和密码

 
 
 
 
 ############################# 硬盘 ############################# 
 
git  clone  https://github.com/grundic/zabbix-disk-performance.git

将lld-disks.py 放入/etc/zabbix/zabbix_agentd.d/scripts目录中 授权zabbix.zabbix  并给予执行权限
userparameter_diskstats.conf 放入到/etc/zabbix/zabbix_agentd.d/  修改userparameter_diskstats.conf中的lld-disks.py 路径

将模板导入到zabbix中




 ############################# Tomcat ############################# 

git  clone https://github.com/zhujinhe/tomcat-zabbix-template.git
在catalina.sh文件中添加如下几行
CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.port=12345 -Djava.rmi.server.hostname=10.141.8.112"

vim  /path/to/your/tomcat/conf/server.xml
Add this line next the the last line of <Listener className=""/>
<Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="12345"/>

wget $URL -O /path/to/your/tomcat/lib/catalina-jmx-remote.jar

修改zabbix-java-gateway.conf配置文件
LISTEN_IP="0.0.0.0"
LISTEN_PORT=10052
PID_FILE="/var/run/zabbix/zabbix_java.pid"




 