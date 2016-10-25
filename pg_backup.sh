#!/bin/sh

export PGPASSWORD=
DATABASE=
USER=
RETENTION=3
DATE=`date +%Y%m%d_%H%M`

find /var/lib/postgresql/*.sql.gz -mtime +$RETENTION -exec rm {} \;
pg_dump $DATABASE -U $USER > /var/lib/postgresql/$DATABASE-dump-$DATE.sql
gzip /var/lib/postgresql/$DATABASE-dump-$DATE.sql

