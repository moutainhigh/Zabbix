```
 user  www www;
 worker_processes  auto;
 error_log  logs/error.log error;
 
 pid        logs/nginx.pid;
 worker_rlimit_nofile    65536;
 
 events
 {
     use epoll;
     accept_mutex off;
     worker_connections  65536;
 }
 
 http
 {
     include       mime.types;
     default_type  text/html;    
     charset UTF-8;
     server_names_hash_bucket_size 128;
     client_header_buffer_size 4k;
     large_client_header_buffers 4 32k;
     client_max_body_size            8m;
  
     open_file_cache max=65536  inactive=60s;
     open_file_cache_valid      80s;
     open_file_cache_min_uses   1;
 
     log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                       '$status $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"';
 
     access_log  logs/access.log  main;
  
     sendfile    on;
     server_tokens off;
 
     fastcgi_temp_path  /tmp/fastcgi_temp;
     fastcgi_cache_path /tmp/fastcgi_cache levels=1:2  keys_zone=cache_fastcgi:128m inactive=30m max_size=1g;
     fastcgi_cache_key $request_method://$host$request_uri;
     fastcgi_cache_valid 200 302 1h;
     fastcgi_cache_valid 301     1d;
     fastcgi_cache_valid any     1m;
     fastcgi_cache_min_uses 1;
     fastcgi_cache_use_stale error timeout http_500 http_503 invalid_header;
 
     keepalive_timeout  60;
 
     gzip  on;
     gzip_min_length 1k;
     gzip_buffers  4 64k;
     gzip_http_version 1.1;
     gzip_comp_level 2;
     gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
########################################################################################################################################### 
#     server
#     {
#         listen       80;
#         server_name  localhost;
#         index        index.html;
#         root         /App/web;
 
#         location ~ .+\.(php|php5)$
#         {
#             fastcgi_pass   unix:/tmp/php.sock;
#             fastcgi_index  index.php;
#             include        fastcgi.conf;
#             fastcgi_cache  cache_fastcgi;
#         }
# 
#         location ~ .+\.(gif|jpg|jpeg|png|bmp|swf|txt|csv|doc|docx|xls|xlsx|ppt|pptx|flv)$
#         {
#             expires 30d;
#         }
# 
#         location ~ .+\.(js|css|html|xml)$
#         {
#             expires 30d;
#         }
# 
#         location /nginx-status
#         {
#             stub_status on;
#             allow 192.168.1.0/24;
#             allow 127.0.0.1;
#             deny all;
#         }
#     }
##############################################################################################################################################
include vhost/*.conf;

  }
```
