```
server
     {
         listen       8089;
         server_name  localhost;
         index        index.php index.html;
         root         /data/web/zabbix;
        
     
 
         location ~ .+\.(php|php5)$
         {
             fastcgi_pass   127.0.0.1:9000;
             fastcgi_index  index.php;
             include        /etc/nginx/fastcgi.conf;
             fastcgi_cache  cache_fastcgi;
         }
 
         location ~ .+\.(gif|jpg|jpeg|png|bmp|swf|txt|csv|doc|docx|xls|xlsx|ppt|pptx|flv)$
         {
             expires 30d;
         }
 
         location ~ .+\.(js|css|html|xml)$
         {
             expires 30d;
         }
 
         location /nginx-status
         {
             stub_status on;
             allow 192.168.1.0/24;
             allow 127.0.0.1;
             deny all;
         }
     }
```
