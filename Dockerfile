FROM sameersbn/ubuntu:14.04.20160827
MAINTAINER helpdesk@techequity.support

ENV PG_APP_HOME="/etc/docker-postgresql"\
    PG_VERSION=9.5 \
    PG_USER=postgres \
    PG_HOME=/var/lib/postgresql \
    PG_RUNDIR=/run/postgresql \
    PG_LOGDIR=/var/log/postgresql \
    PG_CERTDIR=/etc/postgresql/certs

ENV PG_BINDIR=/usr/lib/postgresql/${PG_VERSION}/bin \
    PG_DATADIR=${PG_HOME}/${PG_VERSION}/main

### BEGIN - SHIYGHAN ADDED postgresql-${PG_VERSION}-postgis-2.2 postgresql-${PG_VERSION}-postgis-2.2-scripts
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
 && apt-get update \
 && apt-get install cron \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y acl \
      postgresql-${PG_VERSION} postgresql-client-${PG_VERSION} postgresql-contrib-${PG_VERSION} postgresql-${PG_VERSION}-postgis-2.2 postgresql-${PG_VERSION}-postgis-2.2-scripts \
 && ln -sf ${PG_DATADIR}/postgresql.conf /etc/postgresql/${PG_VERSION}/main/postgresql.conf \
 && ln -sf ${PG_DATADIR}/recovery.conf /etc/postgresql/${PG_VERSION}/main/recovery.conf \
 && ln -sf ${PG_DATADIR}/pg_hba.conf /etc/postgresql/${PG_VERSION}/main/pg_hba.conf \
 && ln -sf ${PG_DATADIR}/pg_ident.conf /etc/postgresql/${PG_VERSION}/main/pg_ident.conf \
 && rm -rf ${PG_HOME} \
 && rm -rf /var/lib/apt/lists/*
### END - SHIYGHAN ADDED postgresql-${PG_VERSION}-postgis-2.2 postgresql-${PG_VERSION}-postgis-2.2-scripts

### BEGIN - SHIYGHAN ADDED 
#Create group and user with GID & UID 1010.
#In this case your are creating a group and user named myguest.
#The GUID and UID 1010 is unlikely to create a conflict with any existing user GUIDs or UIDs in the image.
#The GUID and UID must be between 0 and 65536. Otherwise, container creation fails.
RUN usermod -u 1010 postgres
RUN groupmod -g 1010 postgres

# Add crontab file in the cron directory
COPY crontab /etc/cron.d/backup
RUN chmod 755 /etc/cron.d/backup

# Add files
COPY pg_backup.sh ${PG_HOME}
RUN chmod 755 ${PG_HOME}/pg_backup.sh
RUN touch ${PG_HOME}/pg_backup.log
RUN chmod 0644 ${PG_HOME}/pg_backup.log
### END - SHIYGHAN ADDED 

COPY runtime/ ${PG_APP_HOME}/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 5432/tcp
VOLUME ["${PG_HOME}", "${PG_RUNDIR}"]
WORKDIR ${PG_HOME}
ENTRYPOINT ["/sbin/entrypoint.sh"]
