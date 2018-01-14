
#!/bin/bash
set -e
set -x

function install_tiki() {
    cd /tmp
    curl -jkLo tiki-${TIKI_VERSION}.tar.bz2 "https://downloads.sourceforge.net/project/tikiwiki/Tiki_${TIKI_CODENAME}/${TIKI_VERSION}/tiki-${TIKI_VERSION}.tar.bz2?use_mirror=netcologne"
    tar -xjf tiki-${TIKI_VERSION}.tar.bz2
    /bin/rm -rf /var/www/html /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/users.conf
    mv tiki-${TIKI_VERSION} /var/www/html
    cd /var/www/html
    chmod a+x setup.sh
    cp _htaccess /etc/httpd/conf.d/tiki.conf
    ./setup.sh -u apache -g apache fix
}

functioon configure_apache() {
cat >>/etc/httpd/tiki.conf <<EOF

Listen 443 https
SSLPassPhraseDialog exec:/usr/libexec/httpd-ssl-pass-dialog
SSLSessionCache         shmcb:/run/httpd/sslcache(512000)
SSLSessionCacheTimeout  300
SSLRandomSeed startup file:/dev/urandom  256
SSLRandomSeed connect builtin
SSLCryptoDevice builtin

<VirtualHost _default_:443>
    ErrorLog logs/ssl_error_log
    TransferLog logs/ssl_access_log
    LogLevel warn
    SSLEngine on

    SSLProtocol all -SSLv3
    SSLProxyProtocol all -SSLv3
    SSLHonorCipherOrder on
    SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4
    SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4
    SSLCertificateFile /etc/pki/tls/certs/server.crt
    SSLCertificateKeyFile /etc/pki/tls/private/server.key

    <FilesMatch "\.(cgi|shtml|phtml|php)$">
        SSLOptions +StdEnvVars
    </FilesMatch>

    <Directory "/var/www/cgi-bin">
        SSLOptions +StdEnvVars
    </Directory>
       
    BrowserMatch "MSIE [2-5]" \
        nokeepalive ssl-unclean-shutdown \
        downgrade-1.0 force-response-1.0
           
    CustomLog logs/ssl_request_log \
        "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"
                                    
</VirtualHost>
                                    
EOF
    sed -e 's/^Listen/#Listen/' -i /etc/httpd/httpd.conf
    rm conf.d/ssl.conf 
    cp /etc/pki/tls/certs/localhost.crt /etc/pki/tls/certs/server.crt
    cp /etc/pki/tls/private/localhost.key /etc/pki/tls/private/server.key

}

curl -sSo /tmp/install/functions.sh https://raw.githubusercontent.com/joernott/docker-oc-install-library/master/install_functions.sh
source /tmp/install/functions.sh
install_software ssmtp which
install_tiki
configure_apache
cleanup
