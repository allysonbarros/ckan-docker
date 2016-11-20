####
#
# Dockerfile for building a postgresql;
#
# with scope to ckan
#
####
FROM phusion/baseimage
MAINTAINER Allyson Barros <allysonbarrosrn@gmail.com>

#set env
ENV DEBIAN_FRONTEND noninteractive

#set locale
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

RUN apt-get -qq update && apt-get install -y \
    postgresql-9.5 postgresql-contrib-9.5 \
    postgresql-9.5-postgis-2.2 libpq-dev sudo \
    python-dev libxml2-dev libxslt1-dev libgeos-c1v5

# /etc/ssl/private can't be accessed from within container for some reason
# (@andrewgodwin says it's something AUFS related)
RUN mkdir /etc/ssl/private-copy && \
    mv /etc/ssl/private/* /etc/ssl/private-copy/ && \
    rm -r /etc/ssl/private && \
    mv /etc/ssl/private-copy /etc/ssl/private && \
    chmod -R 0700 /etc/ssl/private && \
    chown -R postgres /etc/ssl/private

ADD postgresql.conf /etc/postgresql/9.5/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.5/main/pg_hba.conf
RUN chown postgres:postgres /etc/postgresql/9.5/main/*.conf
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

VOLUME ["/var/lib/postgresql"]
EXPOSE 5432
CMD ["/usr/local/bin/run"]

# Customize default user/pass/db
ENV POSTGRESQL_USER ckan
ENV POSTGRESQL_PASS ckan
ENV POSTGRESQL_DB ckan
