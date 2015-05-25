#!/bin/bash

if [ -z $HOST ] ; then
    HOST=mysql
fi
blowfish_secret=`tr -cd '[:alnum:]' < /dev/urandom | fold -w15 | head -n1`

PMAROOT=/var/www/html

sed "s/\$cfg\['blowfish_secret'\] = ''/\$cfg\['blowfish_secret'\] = '$blowfish_secret'/" ${PMAROOT}/config.sample.inc.php > ${PMAROOT}/config.inc.php 
sed -i "s/\$cfg\['Servers'\]\[\$i\]\['host'\] = 'localhost'/\$cfg\['Servers'\]\[\$i\]\['host'\] = '$HOST'/"  ${PMAROOT}/config.inc.php 

#There seems a small issue in PMA, the value of a column comment can not longer than 60 char, a hack on the code:
sed -i 's/maxlength="60"/maxlength="1024"/g'  ${PMAROOT}/libraries/operations.lib.php 

echo "starting monit:"
/usr/bin/monit -d 10 -Ic /etc/monitrc
