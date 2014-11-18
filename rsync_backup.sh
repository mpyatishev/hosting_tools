#!/bin/sh

#cat backup.list | while read host dirs 
#do
#	echo $host $dirs
#	rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --exlcude="cache/*" --exclude="sessions/*" --exclude --rsync-path="sudo /usr/local/bin/rsync"
#done
rm -rf /data/backups/backup.7
for i in 7 6 5 4 3 2 1
do
	mv /data/backups/backup.$(expr $i - 1) /data/backups/backup.$i
done
( cd /data/backups/backup && find . -print | cpio -dplm /data/backups/backup.0 )

#S1
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s1.portpc-design.spb.ru:/etc/ /data/backups/backup/s1/etc/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s1.portpc-design.spb.ru:/usr/local/etc/ /data/backups/backup/s1/usr/local/etc/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s1.portpc-design.spb.ru:/var/cron/tabs/ /data/backups/backup/s1/var/cron/tabs/

#S2
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s2.portpc-design.spb.ru:/etc/ /data/backups/backup/s2/etc/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s2.portpc-design.spb.ru:/usr/local/etc/ /data/backups/backup/s2/usr/local/etc/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s2.portpc-design.spb.ru:/usr/local/scripts/ /data/backups/backup/s2/usr/local/scripts/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" --exclude="cache/*" --exclude="sessions/*" --exclude="log/*" --exclude="discobaby.ppd.spb.ru/www/data/tracks/*" rsync@s2.portpc-design.spb.ru:/usr/local/www/data/ /data/backups/backup/s2/usr/local/www/data/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s2.portpc-design.spb.ru:/var/db/mysql/ /data/backups/backup/s2/var/db/mysql/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s2.portpc-design.spb.ru:/var/named/ /data/backups/backup/s2/var/named/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s2.portpc-design.spb.ru:/var/cron/tabs/ /data/backups/backup/s2/var/cron/tabs/

#S3
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s3.portpc-design.spb.ru:/etc/ /data/backups/backup/s3/etc/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s3.portpc-design.spb.ru:/usr/local/etc/ /data/backups/backup/s3/usr/local/etc/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s3.portpc-design.spb.ru:/usr/local/scripts/ /data/backups/backup/s3/usr/local/scripts/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" --exclude="cache/*" --exclude="sessions/*" --exclude="log/*" rsync@s3.portpc-design.spb.ru:/usr/local/www/data/ /data/backups/backup/s3/usr/local/www/data/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s3.portpc-design.spb.ru:/var/db/mysql/ /data/backups/backup/s3/var/db/mysql/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s3.portpc-design.spb.ru:/var/named/ /data/backups/backup/s3/var/named/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s3.portpc-design.spb.ru:/var/cron/tabs/ /data/backups/backup/s3/var/cron/tabs/

#S4
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s4.portpc-design.spb.ru:/etc/ /data/backups/backup/s4/etc/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s4.portpc-design.spb.ru:/usr/home/backup/ /data/backups/backup/s4/usr/home/backup/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s4.portpc-design.spb.ru:/usr/local/etc/ /data/backups/backup/s4/usr/local/etc/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s4.portpc-design.spb.ru:/usr/local/scripts/ /data/backups/backup/s4/usr/local/scripts/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" --exclude="cache/*" --exclude="sessions/*" --exclude="log/*" rsync@s4.portpc-design.spb.ru:/usr/local/www/data/ /data/backups/backup/s4/usr/local/www/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s4.portpc-design.spb.ru:/var/db/mysql/ /data/backups/backup/s4/var/db/mysql/
rsync -aHz --numeric-ids --delete --delete-excluded -x -v --stats --rsync-path="sudo /usr/local/bin/rsync" rsync@s4.portpc-design.spb.ru:/var/cron/tabs/ /data/backups/backup/s4/var/cron/tabs/
