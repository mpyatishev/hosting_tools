#!/usr/bin/awk -f

#converts apache virtualhosts to nginx servers

BEGIN	\
{
	IGNORECASE = 1 
}
FNR == 1\
{
#	print FILENAME
	"/usr/bin/basename "FILENAME | getline filename
	close("/usr/bin/basename "FILENAME)
	dir = "/usr/local/etc/nginx/virtual/"
	print (dir filename)
}
/#/ {next}
/ServerName/ { server_name = $2 }
/ServerAlias/ { for (i = 2; i <= NF; i++) server_name = server_name " " $i }
/DocumentRoot/ { root = $2 }
/ErrorLog/ { error_log = $2 }
/CustomLog/ { custom_log = $2 }
/<\/VirtualHost>/	\
{ 
	if ( !root ) next
	print "\
server {\
#	limit_conn gulag 5;\
\
	listen       80;\
	server_name  " server_name ";\
\
	access_log  ", custom_log, "main;\
	error_log   ", error_log ";\
\
	# Main location\
	location / {\
		proxy_pass         http://127.0.0.1:8080/;\
		proxy_http_version 1.1;\
	#	proxy_cache cache;\
		proxy_cache off;\
		proxy_set_header   Host             $host;\
		proxy_set_header   X-Real-IP        $remote_addr;\
		proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;\
\
		client_max_body_size       40m;\
		client_body_buffer_size    128k;\
\
		proxy_connect_timeout      90;\
		proxy_send_timeout         90;\
		proxy_read_timeout         900;\
\
		proxy_buffer_size          4k;\
		proxy_buffers              4 32k;\
		proxy_busy_buffers_size    64k;\
		proxy_temp_file_write_size 64k;\
	}\
\
	location @fallback {\
		proxy_pass         http://127.0.0.1:8080;\
		proxy_http_version 1.1;\
	#	proxy_cache cache;\
		proxy_cache off;\
		proxy_set_header   Host             $host;\
		proxy_set_header   X-Real-IP        $remote_addr;\
		proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;\
\
		client_max_body_size       40m;\
		client_body_buffer_size    128k;\
\
		proxy_connect_timeout      90;\
		proxy_send_timeout         90;\
		proxy_read_timeout         900;\
\
		proxy_buffer_size          4k;\
		proxy_buffers              4 32k;\
		proxy_busy_buffers_size    64k;\
		proxy_temp_file_write_size 64k;\
	}\
\
	location ~ ^/captcha/ {\
		proxy_pass         http://127.0.0.1:8080;\
		proxy_cache off;\
		proxy_set_header   Host             $host;\
		proxy_set_header   X-Real-IP        $remote_addr;\
		proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;\
	}\
\
	location ~ /\\.ht {\
		deny  all;\
	}\
\
	location ~ ^/mail/[^.+] {\
		deny  all;\
	}\
\
	# Static files location\
	location ~* (txt|htm|html|xml|jpg|jpeg|gif|png|ico|css|zip|tgz|gz|rar|bz2|doc|xls|exe|pdf|ppt|tar|mid|midi|wav|bmp|rtf|js|css|webm|ogv|mp4)$ {\
		gzip_static on;\
		expires 7d;\
		root   ", root, ";\
		try_files $uri @fallback;\
	}\
}" >> (dir filename)
	close(dir filename)
	server_name = ""
	root = ""
}
