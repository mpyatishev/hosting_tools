#!/usr/bin/awk -f

#inventarize hostings domains

BEGIN	\
{
	IGNORECASE = 1 
	"hostname" | getline hostname
}
FNR == 1\
{
#	print FILENAME
	"/usr/bin/basename "FILENAME | getline filename
	close("/usr/bin/basename "FILENAME)
	dir = "/usr/local/etc/apache22/virtual/"
#	print (dir filename)
}
/#/ {next}
/ServerName/ { server_name = $2 }
/ServerAlias/ { for (i = 2; i <= NF; i++) server_name = server_name " " $i }
/DocumentRoot/ { root = $2 }
/ErrorLog/ { error_log = $2 }
/CustomLog/ { custom_log = $2 }
/Redirect/ { redirect_to = $3 }
/<\/VirtualHost>/	\
{ 
## for determine hostings
#	gsub(" ", "\n", server_name)
#	print server_name

	if (root)
	{
		"du -sk "root | getline size
		close("du -sk "root)
		split(size, ar)
	}
	print (dir filename)";"server_name";"redirect_to";"ar[2]";"ar[1]";"hostname
	ar[1] = ""
	ar[2] = ""
	server_name = ""
	redirect_to = ""
	root = ""
#	print "----------------------------------------\n"
}
