#!/bin/bash

if [ -z $HOST ] ; then
    HOST=mysql
fi
blowfish_secret=`tr -cd '[:alnum:]' < /dev/urandom | fold -w15 | head -n1`

sed "s/\$cfg\['blowfish_secret'\] = ''/\$cfg\['blowfish_secret'\] = '$blowfish_secret'/" /var/www/html/config.sample.inc.php > /var/www/html/config.inc.php 
sed -i "s/\$cfg\['Servers'\]\[\$i\]\['host'\] = 'localhost'/\$cfg\['Servers'\]\[\$i\]\['host'\] = '$HOST'/"  /var/www/html/config.inc.php 

echo "starting monit:"
/usr/bin/monit -d 10 -Ic /etc/monitrc
