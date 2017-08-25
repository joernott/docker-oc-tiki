
#!/bin/bash
set -e
set -x

curl -sSo /tmp/install/functions.sh https://raw.githubusercontent.com/joernott/docker-oc-install-library/master/install_functions.sh
source /tmp/install/functions.sh
install_software ssmtp
cd /tmp
curl -jkLo tiki-${TIKI_VERSION}.tar.gz "https://downloads.sourceforge.net/project/tikiwiki/Tiki_${TIKI_CODENAME}/${TIKI_VERSION}/tiki-${TIKI_VERSION}.tar.gz?use_mirror=netcologne"
tar -xzf tiki-${TIKI_VERSION}.tar.gz
/bin/rm -rf /var/www/html /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/users.conf
mv tiki-${TIKI_VERSION} /var/www/html
cd /var/www/html
chmod a+x setup.sh
mv _htaccess .htaccess
./setup.sh -u apache -g apache fix
cleanup
