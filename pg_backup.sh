#!/bin/sh

export PGPASSWORD=YourPassword
DATABASE=YourDatabaseName
USER=YourDatabaseUser
RETENTION=3
DATE=`date +%Y%m%d_%H%M`

find /var/lib/postgresql/ -name "*.sql.bz2" -mtime +$RETENTION -exec rm {} \;
pg_dump $DATABASE -U $USER > /var/lib/postgres/$DATABASE-dump-$DATE.sql

