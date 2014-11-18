#!/bin/sh

for i in `echo 'show databases;' | mysql -B -r --skip-column-names`
do
	echo $i
	mysqldump $i > /usr/home/backup/$i.sql
	if [ -e /usr/home/backup/$i.sql.gz ]
	then
		mv -f /usr/home/backup/$i.sql.gz /usr/home/backup/$i.sql.0.gz
	fi
	gzip -f /usr/home/backup/$i.sql
done
