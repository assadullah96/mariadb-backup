#!/bin/bash
MHOST=localhost
MUSER=root
MPASS=assad@1234
BACKUPDIR="/mnt/backup"

MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"

DBPREFIX="$(hostname -s).mysqldb"

echo "Run MySQL backup"
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do
    FILE=${BACKUPDIR}/${DBPREFIX}.${db}.`date +%Y%m%d`.gz
    $MYSQLDUMP --no-tablespaces --skip-lock-tables -u $MUSER -h $MHOST -p$MPASS $db | $GZIP -9 > $FILE
done 

find  -name "${BACKUPDIR}/${DBPREFIX}*" -type f -mtime +5 -exec rm -f '{}' ';'
