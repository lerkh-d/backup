#!/usr/bin/env bash

dbhost="localhost"
dbpass="q12we34rt5"
dbuser="root"

_date="/bin/date"
_mysqldump="/usr/bin/mysqldump"

BACKUP_PATH="/backup/mysqldumps/"

DB_NAMES=$1
DATE=`$_date '+_%Y_%m_%d'`


for DBNAME in ${DB_NAMES};
  do
  $_mysqldump -h${dbhost} -u${dbuser} -p${dbpass} ${DBNAME} | gzip -c >${BACKUP_PATH}/${DBNAME}${DATE}.sql.gz
  done

find ${BACKUP_PATH} -type f -mtime +60 -exec rm {} \;

exit 0
