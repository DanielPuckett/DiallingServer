#!/bin/sh
cd /opt/DiallingServer
chown www-data DiallingServer.sh runVSSP.sh xfileread.bash
chmod u+rwx DiallingServer.sh runVSSP.sh xfileread.bash
ln -s /tmp ./tmp
ln -s /opt/VSSP-Softphone/VSSP ./VSSP
