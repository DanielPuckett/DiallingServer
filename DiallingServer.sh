#!/bin/bash

# Dialling Server is a 1 second idle loop looking for a non zero size did.ticket to process
# Upon finding a ticket, it calls xfileread.bash to process the ticket.
# then wipe ticket to zero length

PHONES=6

source /var/www/DiallingSite/processcontrol.src

touch ./tmp/did.ticket

while [ 1 ]; do
  sleep 1;
  if [ -s ./tmp/did.ticket ]; then
    A="START"
    P="CRAFTRECORDS"
    processcontrol

    L=$(($(($(cat ./tmp/did.ticket|wc -l) - 1 ))*2))

    for i in $(echo "1 2 3 4 5 6"|colrm $L); do
      P="PHONE${i}"
      processcontrol
    done
    /bin/echo -n "" > ./tmp/did.events.log
    /bin/echo "working" > ./tmp/did.ticket.working
    /bin/bash ../DiallingServer/xfileread.bash ./tmp/did.ticket $PHONES ./tmp/sip.in.

    sleep 10
    A="STOP"
    for i in $(echo "1 2 3 4 5 6"|colrm $L); do
      P="PHONE${i}"
      processcontrol
    done
    P="CRAFTRECORDS"
    processcontrol

    /bin/echo -n "" > ./tmp/did.ticket
    /bin/echo -n "" > ./tmp/did.ticket.working
    /bin/echo "CLOSED" >> ./tmp/did.events.log
  fi
done
