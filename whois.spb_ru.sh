#!/bin/tcsh

foreach zone (`sed -En 's/zone.*"(.*spb\.ru)".*/\1/p' /etc/namedb/named.conf | grep -v '.ppd' | sort`)
	set admin = `whois -h whois.relcom.ru $zone | sed -En 's/admin-c: +(.+)/\1/p'`
	echo $zone, $admin
	sleep 30
end
