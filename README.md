# Docker image: Tiki 15 LTS on CentOS 7 with Apache 2.4 and PHP 5.6 from IUS
This image starts Apache 2.4 from the IUS repository (2.4.37) to serve Tiki LTS.

To provide a static configuration file, mount it to /var/www/db/local.php.

The following folders should be made persistent:
* /var/www/files
* /var/www/dump

To create the lock file, start the container with the cmd "LOCK"

## Usage:
```
docker run -d -p 80:80  \
    -v /srv/docker/tiki/var/www/html/db/local.php:/var/www/html/db/local.php \
    -v /srv/docker/tiki/var/www/html/files:/var/www/html/files \
    -v /srv/docker/tiki/var/www/html/dump:/var/www/html/dump \
    registry.ott-consult.de/oc/tiki:lts LOCK
```
