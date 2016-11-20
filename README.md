# installation /build-process

## allysonbarros/ckan
```
git clone --recursive https://github.com/allysonbarros/ckan-docker.git
cd ckan-docker
docker build -t allysonbarros/ckan:latest .
```

### allysonbarros/ckan-solr
```
cd contrib/docker/solr
docker build -t allysonbarros/ckan-solr:latest .
```

### allysonbarros/ckan-postgresql
```
cd contrib/docker/postgresql
docker build -t allysonbarros/ckan-postgresql:latest .
```

# run ckan
## solr
```
docker run -d --name ckan_solr allysonbarros/ckan-solr:latest
```

## postgresql
```
docker run -d --name ckan_db allysonbarros/ckan-postgresql:latest
```

## ckan
```
docker run -it --rm --link ckan_solr:solr --link ckan_db:db -p 80:80  --name ckan_ckan allysonbarros/ckan:latest /bin/bash
```
within the container:
```
/sbin/my_init
```

or with
```
docker run -it --rm --link ckan_solr:solr --link ckan_db:db -p 80:80  --name ckan_ckan allysonbarros/ckan:latest
```

### ckan configuration

The ckan.ini configuration file is created during container start. The following configuration parameter can be set on ``docker run`` using the ``-e <VARIABLE_NAME>=<VALUE> [-e ...]``:

* General settings
	* ``CKAN_SITE_URL`` (default: http://localhost)
	* ``CKAN_DEBUG`` (False)
	* ``CKAN_PLUGINS`` - add additional plugins (unset)
	* ``DB_FT_SEARCH_LANG`` (english)
* Internationalisation Settings
	* ``CKAN_LOCALE`` (en)
* Feeds Settings
	* ``CKAN_FEED_AUTHORITY``(unset)
	* ``CKAN_FEED_DATE``(unset)
	* ``CKAN_FEED_AUTHOR`` (unset)
	* ``CKAN_FEED_AUTHOR_LINK`` (unset)
* storage settings
	* ``CKAN_STORAGE_PATH`` (/var/lib/ckan)
* activity stream
	* ``CKAN_ACTIVITY_STREAM_ENABLED`` (True)
* Email settings
	* ``EMAIL_TO`` (ckan-admin@localhost)
	* ``EMAIL_FROM`` (ckan_instance@localhost)
	* ``EMAIL_SMTP_SERVER`` (smtp.localhost)
	* ``EMAIL_SMTP_STARTTLS`` (True)
	* ``EMAIL_SMTP_USER`` (EXAMPLEUSER)
	* ``EMAIL_SMTP_PASS`` (EXAMPLEPASS)
	* ``EMAIL_SMTP_EMAIL_FROM`` (ckan_instance@localhost)
