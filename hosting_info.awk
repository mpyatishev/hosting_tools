#!/usr/bin/awk -f

BEGIN   \
{
	IGNORECASE = 1 
	vhost = ""
	print "DocumentRoot;ServerName;ServerAlias;Redirect;"
}
#FNR == 1\
#{
##       print FILENAME
#	"/usr/bin/basename "FILENAME | getline filename
#	close("/usr/bin/basename "FILENAME)
#	dir = "/usr/local/etc/nginx/virtual/"
#	print (dir filename)
#}
/#/ {next}
/<VirtualHost.*>/ { vhost = "start" }
/ServerName/ { server_name = $2 }
/ServerAlias/ { for (i = 2; i <= NF; i++) server_aliases = server_aliases ", " $i; sub(", ", "", server_aliases) }
/DocumentRoot/ { root = $2 }
/Redirect/ { redirect = $3 }
/<\/VirtualHost>/       \
{ 
	if ( !vhost )
	{
		server_aliases = "";
		next;
	}
	print root";"server_name";"server_aliases";"redirect";"

	vhost = "";
	root = "";
	server_name = "";
	server_aliases = "";
	redirect = "";
}
