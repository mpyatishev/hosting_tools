#!/usr/bin/awk -f

BEGIN   \
{
	IGNORECASE = 1 
	server = ""
	print "DocumentRoot;ServerName;ServerAlias;Redirect;"
}
/#/ {next}
/server {/ { server = "start" }
/server_name/ { for (i = 2; i <= NF; i++) server_name = server_name ", " $i; sub(", ", "", server_name); sub(";", "", server_name)  }
/rewrite/ { redirect = $3 }
/^}/       \
{ 
	if ( !server || !redirect )
	{
		server_name = "";
		next;
	}
	print ";"server_name";"";"redirect";"

	server = "";
	server_name = "";
	redirect = "";
}
