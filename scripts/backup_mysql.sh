#!/bin/bash

BACKUPLOCATION=/home/db-back
MUSER="root"
MPASS="pass"
MHOST="localhost"

mkdir -p $BACKUPLOCATION
innobackupex --defaults-file=/etc/my.cnf --throttle=10 --user=$MUSER --password=$MPASS --compress --parallel=4 $BACKUPLOCATION > /tmp/backupdb_log 2>&1
#older then 3 day
for DEL in `find $BACKUPLOCATION -mindepth 1 -maxdepth 1 -type d -mmin +4000 -printf "%P\n"`; do
        rm -rf $BACKUPLOCATION/$DEL
done

tail -2 /tmp/backupdb_log| egrep "completed OK\!" || mail -s "Error backup db on co-node01.eksmo.ru" das-ich@eksmo.ru < /tmp/backupdb_log
