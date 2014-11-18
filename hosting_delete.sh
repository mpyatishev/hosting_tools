#!/bin/sh

user=`ls -ld /www/$1 | cut -d' ' -f 4`
echo user $user
home=`pw usershow $user | cut -d':' -f 9`
echo user home $home
if [ $home != "/www/$1" ] 
then
	echo directories differ: $1 $home
	exit 1
fi

#echo "Deleting logs...."
chflags -R 0 /www/$1
#rm -rf /www/$1/log/*

echo "Backuping site...."

echo "  Creating archive $1.tbz"
tar cypf $1.tbz -W exclude='log/*' /www/$1

echo "  Creating backup directory"
ssh root@m2.portpc-design.spb.ru "mkdir /home/max/backup/$1"

echo "  Moving $1.tbz to backup directory"
if `scp $1.tbz root@m2.portpc-design.spb.ru:/home/max/backup/$1`
then
	echo "    Unlinking $1.tbz"
#	rm $1.tbz
fi

if [ -n "$2" ] 
then
	echo "  Moving DB archive $2.gz to backup directory"
	if `scp /home/backup/$2.gz root@m2.portpc-design.spb.ru:/home/max/backup/$1`
	then
#		rm /home/backup/$2.gz
		echo "    Droping DB $2"
#		echo "drop database $2" | mysql 
	fi
fi

#grep -li $1 /etc/namedb/master/*
#grep -li $1 /usr/local/etc/apache2/virtual/*

echo "Deleting recursivly user $user"
#pw userdel $3 -r
