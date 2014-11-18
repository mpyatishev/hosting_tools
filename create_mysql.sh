#!/bin/sh

if [ -z $@ ]
then
	echo "Usage: $0 <database>"
	exit
fi

DB=$1
PWD=`pwgen -cn 8`

mysqladmin create $DB
mysql -e "grant all privileges on ${DB}.* to ${DB}@'%' identified by '${PWD}'"

echo "DB: ${DB}"
echo "l: ${DB}"
echo "p: ${PWD}"
