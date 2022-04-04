#!/bin/sh
cd /opt/DiallingServer
chown www-data DiallingServer.bash runVSSP.bash xfileread.bash
chmod u+rwx DiallingServer.bash runVSSP.bash xfileread.bash
ln -s /tmp ./tmp
ln -s /opt/VSSP-Softphone/VSSP ./VSSP
