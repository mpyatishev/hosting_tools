#!/bin/sh

site=$1

du -sh /www/$site
grep $site /usr/local/etc/apache2/virtual/*
nslookup $site
read -p "delete $site(yes/no)?" yesno

if [ "$yesno" = "yes" ]
then
	echo deleting $site
	chflags -R 0 /www/$site
	user=`stat -f %Su /www/$site`
	echo $user
	sed -Ee 's/^/#/g' -i '' /usr/local/etc/apache2/virtual/$site
	cat <<TMP >>/usr/local/etc/apache2/virtual/$site
<VirtualHost *:80>
	ServerName $site
	RedirectPermanent / http://lenera.ru
</VirtualHost>
TMP
	pw userdel $user -r
	rm -rf /www/$site
	echo $site deleted
fi
