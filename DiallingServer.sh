#!/bin/sh

# Dialling Server is a 1 second idle loop looking for a non zero size did.ticket to process
# Upon finding a ticket, it calls xfileread.bash to process the ticket.
# then wipe ticket to zero length

PHONES=6

touch ./tmp/did.ticket

while [ 1 ]; do
  sleep 1;
  if [ -s ./tmp/did.ticket ]; then
    /bin/echo -n "" > ./tmp/did.events.log
    /bin/echo "working" > ./tmp/did.ticket.working
    /bin/bash ../DiallingServer/xfileread.bash ./tmp/did.ticket $PHONES ./tmp/sip.in.
    /bin/echo -n "" > ./tmp/did.ticket
    /bin/echo -n "" > ./tmp/did.ticket.working
    /bin/echo "CLOSED" >> ./tmp/did.events.log
  fi
done
