####
#
# Dockerfile for building a ckan;
#
# with scope to ckan
#
####
FROM phusion/baseimage
MAINTAINER Allyson Barros <allysonbarrosrn@gmail.com>

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

ENV DEBIAN_FRONTEND noninteractive

ENV HOME /root
ENV CKAN_HOME /usr/lib/ckan/default
ENV CKAN_CONFIG /etc/ckan/default
ENV CKAN_DATA /var/lib/ckan
ENV CONFIG ${CKAN_CONFIG}/ckan.ini
ENV CKAN_MAX_FILE_SIZE 10
ENV CKAN_MAX_IMAGE_SIZE 2

# Install required packages
RUN apt-get -y update && apt-get -y install \
    python-minimal python-dev python-virtualenv \
    libevent-dev libpq-dev nginx-light \
    apache2 libapache2-mod-wsgi \
    postfix libxml2-dev libxslt1-dev libgeos-c1 \
    build-essential git wget curl

# Install CKAN
RUN virtualenv $CKAN_HOME
RUN mkdir -p $CKAN_HOME $CKAN_CONFIG $CKAN_DATA
RUN chown www-data:www-data $CKAN_DATA

# put ckan code in place and install dependencies
ADD ckan $CKAN_HOME/src/ckan/
RUN $CKAN_HOME/bin/pip install -r $CKAN_HOME/src/ckan/requirements.txt
RUN $CKAN_HOME/bin/pip install -e $CKAN_HOME/src/ckan/
RUN ln -s $CKAN_HOME/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini
ADD ./contrib/docker/apache.wsgi $CKAN_CONFIG/apache.wsgi

# Configure apache
ADD ./contrib/docker/apache.conf /etc/apache2/sites-available/ckan_default.conf
RUN echo "Listen 8080" > /etc/apache2/ports.conf
RUN a2ensite ckan_default
RUN a2dissite 000-default

# Configure nginx
ADD ./contrib/docker/nginx.conf /etc/nginx/nginx.conf
RUN mkdir /var/cache/nginx

# Configure postfix
ADD ./contrib/docker/main.cf /etc/postfix/main.cf

# Configure runit
ADD ./contrib/docker/my_init.d /etc/my_init.d
ADD ./contrib/docker/svc /etc/service
CMD ["/sbin/my_init"]

VOLUME ["/var/lib/ckan"]
EXPOSE 80

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
