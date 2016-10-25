#!/bin/sh

export PGPASSWORD=YourPassword
DATABASE=YourDatabaseName
USER=YourDatabaseUser
RETENTION=3
DATE=`date +%Y%m%d_%H%M`

find /var/lib/postgres/backup/ -name "*.sql.bz2" -mtime +$RETENTION -exec rm {} \;
pg_dump $DATABASE -U $USER > /var/lib/postgres/backup/$DATABASE-dump-$DATE.sql

