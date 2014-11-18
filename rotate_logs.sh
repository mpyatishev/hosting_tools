#!/bin/sh

today=$(date +%Y-%m-%d)
www_dir='/www/'
find_str=''
zip=$(which zip)
zip_args='-j --verbose'

for log in $( find $www_dir \( -name 'access' -or -name 'error' \) -and \( -path '*/log/*' -or -path '*/logs/*' \) )
do
	name=$(basename $log)
	dir=$(dirname $log)
	echo $log

	$zip $zip_args $dir/${name}_${today}.zip $log
	cat /dev/null > $log
done
