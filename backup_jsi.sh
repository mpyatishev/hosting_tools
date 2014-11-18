#!/bin/sh

cd /www/jsi.spb.ru/backup

day=`date "+%A"`

tar cyPpf jsi_$day.tbz --exclude "*backup*" /www/jsi.spb.ru/
mysqldump -u jsi -p6yAV80wOk1WFk jsi | gzip > jsi_sql_$day.gz

if [ `date "+%u"` = 7 ]
then
	for i in 3 2 1
	do
		j=`expr $i + 1`
		mv jsi_$i.tbz jsi_$j.tbz
		my jsi_sql_$i.gz jsi_sql_$j.gz
	done
	cp jsi_$day.tbz jsi_1.tbz
	cp jsi_sql_$day.gz jsi_sql_1.gz
fi
