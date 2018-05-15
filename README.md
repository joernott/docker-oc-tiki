# Docker image: Tiki 15 LTS and 18.1 on CentOS 7 with Apache 2.4 and PHP 5.6 from IUS
These images serve Tiki LTS and current

To provide a correct ssl certificate and key, mount them in
* /etc/pki/tls/certs/server.crt
* /etc/pki/tls/private/server.key
* /etc/pki/tls/certs/chain.crt (if you need a certificate chain)

Set the enviromnemt variable SERVERNAME to math thew server name to the certificate.

## Persistent files

There are two ways of handling persistent files:

### Mount from various locations
To provide a static configuration file, mount it to /var/www/db/local.php.

The following folders should be made persistent:
* /var/www/html/files
* /var/www/html/dump
* /var/www/html/img/wiki
* /var/www/html/img/wiki_up

The folders can be omitted if you store everything in the database. 

### Mount one data directory /data
If you use docker swarm and centrally abailable storages, mounting one file and 4 directories is a tedious task.
If you use ceph and rexray (as I do), the minimum size for a volume is 1GiB, so it makes no sense to have a 1GiB
volume for a single php config file.

Thus, by providing a single mounted persistent storage in /data and setting the DATADIR environment variable, you
can facilitate storage handling. Setting the environment variable will copy the already existing content of the
four directories dump, files, img/wiki and img/wiki_up into /data and create symlinks for them.

It will also create a /data/db/folder and copy an existing local.php from /var/www/html/db/local.php into that
folder if no such destination exists. This file will also be symlinked (if possible).

It will also handle SSL certificates by copying *.crt files from /data/ssl to /etc/pki/tls/certs and
*.key files to /etc/pki/tls/private/.

Migrating from the multiple mounts can be achieved by mounting the old folders and config together with /data and
setting the environment variable MIGRATE_DATADIR. The container stops after a successful migration.

## Environment variables

| Variable   | Purpose                                                                                   |
|------------|-------------------------------------------------------------------------------------------|
| LOCK       | To create the lock file, set this to any non-empty value                                  |
| SERVERNAME | Specify the Servername for the VHost, this should match the SSL certificate               | 
| SERVERALIAS| Specify ServerAlias directive for the VHost, the entries should match the SSL certificate |
| MIGRATE_DATADIR | Handles a central data directory mounted at /data (see above)                        |


## Usage:
```
docker run -d -p 443:443  \
    -e LOCK=yes \
    -e SERVERNAME=www.example.com \
    -e SERVERALIAS=example.com \
    -v /etc/pki/tls/certs/www.example.com.crt:/etc/pki/tls/certs/server.crt \
    -v /etc/pki/tls/certs/chain.example.com.crt:/etc/pki/tls/certs/chain.crt \
    -v /etc/pki/tls/private/www.example.com.key:/etc/pki/tls/private/server.key \
    -v /srv/docker/tiki/var/www/html/db/local.php:/var/www/html/db/local.php \
    -v /srv/docker/tiki/var/www/html/files:/var/www/html/files \
    -v /srv/docker/tiki/var/www/html/dump:/var/www/html/dump \
    -v /srv/docker/tiki/var/www/html/img/wiki:/var/www/html/img/wiki \
    -v /srv/docker/tiki/var/www/html/img/wiki_up:/var/www/html/img/wiki_up \
    --add-host mail:mail.example.com \
    registry.ott-consult.de/oc/tiki:lts
```
