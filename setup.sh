#!/bin/sh
chown www-data DiallingServer.sh runVSSP.sh xfileread.bash
chmod u+rwx DiallingServer.sh runVSSP.sh xfileread.bash
ln -s /opt/DiallingServer /var/www/DiallingServer
ln -s /tmp ./tmp
