#!/bin/sh

RSYNC="rsync -zrlHpogDt --delete --numeric-ids -x -v"

$RSYNC /usr/local/etc/apache2/virtual/ root@m2.portpc-design.spb.ru:/usr/local/etc/apache2/virtual/
$RSYNC /var/named/etc/namedb/ root@m2.portpc-design.spb.ru:/etc/namedb/
$RSYNC /usr/local/scripts/ root@m2.portpc-design.spb.ru:/usr/local/scripts/
$RSYNC /etc/ root@m2.portpc-design.spb.ru:/usr/local/backup/etc/
$RSYNC /usr/home/cvs/ root@m2.portpc-design.spb.ru:/usr/home/cvs/
