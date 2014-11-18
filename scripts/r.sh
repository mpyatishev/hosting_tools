#!/bin/sh

RSYNC="rsync -rlHpogDt --delete --numeric-ids -x -v"

$RSYNC --exclude=/etc/fstab / /mnt/root/
$RSYNC /tmp/ /mnt/tmp/
$RSYNC /var/ /mnt/var/
$RSYNC --exclude=/usr/local/var/spool/imap /usr/ /mnt/usr/
