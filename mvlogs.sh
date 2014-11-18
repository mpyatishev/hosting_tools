#!/bin/sh

#for log in `find /www/ -path '*/log/access' -or -path '*/log/error'`
while read log
do
	dir=`dirname "$log"`
	dir=`dirname "$dir"`
	logname=`basename $log`
	if [ ! -d "/var/log/${dir}" ]
	then
		mkdir -vp "/var/log${dir}"
	fi
	if [ ! -L "$log" ]
	then
		mv -v "$log" "/var/log${dir}/${logname}"
		ln -vs "/var/log${dir}/${logname}" "$log"
	fi
done
