#!/bin/sh

RSYNC="rsync -zrlHpogDt --delete --numeric-ids -x -v"

$RSYNC /usr/local/www/data/ root@m2.portpc-design.spb.ru:/usr/local/www/data/
