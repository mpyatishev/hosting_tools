#~/bin/sh

for host in `ls -1`
do
	cp $host $host.bak
	awk -f ~max/work/add_captcha.awk $host.bak > $host
done
