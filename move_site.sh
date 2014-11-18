#!/bin/sh

if [ $# -lt 2 ]
then
	echo "to few arguments!"
	echo "usage: $0 site remote_user dst_host db dbuser db_passwd"
	exit 1
fi

site=$1
duser=$2
dhost=$3
db=$4
dbuser=$5
passwd=$6
dst=$duser@$dhost

user=`ls -ld /www/$site | cut -d' ' -f 4`
echo user $user
home=`pw usershow $user | cut -d':' -f 9`
echo user home $home
if [ $home != "/www/$site" ] 
then
	echo directories differ: $site $home
	exit 1
fi

if [ "$db" = "user" ]
then
	db=$user
fi

#chflags -R 0 /www/$site

echo "Backuping site...."
echo "  Locking user account $user"
pw lock $user

echo "  Dumping DB $db"
dbcharset=`echo status | mysql $db | egrep 'Db +characterset' | cut -d':' -f 2 | sed -E 's/	//g'`
mysqldump --default-character-set=$dbcharset $db > /www/$site/$db.sql
echo "  Creating archive $site.tbz"
tar cypf $site.tbz -W exclude='log/*' -W exclude='tmp/*' -W exclude='awstats.tmp*' /www/$site

echo "  Installing site..."
if `scp $site.tbz $dst:/home/backup`
then
#	echo "    Unlinking $site.tbz"
#	rm $site.tbz
	vhost=/usr/local/etc/apache22/virtual/$site
	if [ ! -e $vhost ]
	then
		vhost=`grep -li $site /usr/local/etc/apache2/virtual/*`
	fi

	namedzone=/etc/named/master/$site
	if [ ! -e $namedzone ]
	then
		namedzone=`grep -li $site /etc/namedb/master/*`
	fi
	echo "    Creating user on $dst"
	ssh $dst "sudo pw useradd $user -d /www/$site -m"

	echo "    Unpacking..."
	ssh $dst "sudo tar xypPf /home/backup/$site.tbz -C /"

#	echo "    Creating DB user $dbuser"
#	echo GRANT USAGE ON '*.*' TO $dbuser@\'%\' IDENTIFIED BY \'$passwd\' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0
#	ssh $dst "echo GRANT USAGE ON \*.\* TO $dbuser@\'%\' IDENTIFIED BY \'$passwd\' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 | sudo -H mysql"
#	echo "    Creating DB $db"
#	ssh $dst "echo CREATE DATABASE IF NOT EXISTS $db CHARSET $dbcharset | sudo -H mysql"
##	ssh $dst "sudo -H mysqladmin --default-character-set=$dbcharset create $db"
#
#	echo "    Granting permissions on $db for $user"
#	ssh $dst "echo GRANT ALL PRIVILEGES ON $db.\* TO $dbuser@\'%\' | sudo -H mysql"
#
#	echo "    Installing DB $db"
#	ssh $dst "sudo -u $user cat /www/$site/$db.sql| sudo -H mysql $db"
#
#	echo "    Installing $vhost in /usr/local/etc/apache22/virtual"
#	scp $vhost $dst:/usr/local/etc/apache22/virtual/
#
#	echo "    Correcting domain-record in $namedzone"
##	sed -E "s/89.108.86.110/$dhost/g"-i bak $namedzone
fi
