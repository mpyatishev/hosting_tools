#!/bin/sh

sites="btk.ppd.spb.ru btk.com.ua wexler.ru izumi-electronics.com izumi-electronics.jp izumi-electronics.ru izumi.ru"
dbs="btkppd btkcom wexler izumi izumielectronic1 izumielectronic2 izumielectronics"
db_user="btk"
db_pwd='s^xMJb4E<['

for site in $sites
do
	ls -d /www/${site}
	tar cpPzf /www/btk.ppd.spb.ru/archive/${site}.tbz -W exclude="log/*" -W exclude="archive/*" /www/${site}
done

for db in $dbs
do
	mysqldump -h dbsrv -u ${db_user} -p${db_pwd} ${db}|gzip > /www/btk.ppd.spb.ru/archive/${db}.sql.gz
done

chown btk_archive /www/btk.ppd.spb.ru/archive/*
