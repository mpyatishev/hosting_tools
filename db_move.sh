#!/bin/sh

for i in `echo 'show databases;' | mysql -B -r --skip-column-names`
do
	if [ "$i" != "mysql" -a "$i" != "information_schema" ]
	then
		echo "dumping $i"
		mysqldump -q --add-drop-database --databases $i |tee $i.sql|ssh max@s4 "cat -|mysql"
	fi
done
