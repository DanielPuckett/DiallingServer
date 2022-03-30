#!/bin/bash

# This version uses local tmp softlink

INPIPE=./tmp/sip.pipe.$1.`date +%H%M%S`
OUTFILE=./tmp/sip.out.$1
INFILE=./tmp/sip.in.$1

#echo "----------------------------------------------------------------" 1>&2
#echo "Script Start, $1 is my tag" 1>&2
#echo "Background's stdout will be found in $OUTFILE" 1>&2
#echo "You can write to background's stdin by writing to $INFILE" 1>&2
#echo "reset and  stop will be processed locally" 2>&1
#echo "----------------------------------------------------------------" 1>&2

rm -f $INPIPE $OUTFILE $INFILE
rm -f ./tmp/sip.pipe.$1.*

background=0

sighandler() {
  ps -p $background > /dev/null
  [ $? -eq 0 ] kill -9 $background  
}

trap sighandler EXIT

run=1
while [ $run -eq 1 ]; do

  mkfifo $INPIPE
  touch $INFILE
  chmod ugo+rw $INFILE
#  echo "   Created new file environment" 1>&2

  ../DiallingServer/VSSP $2 $3 $4 $5 $6 < $INPIPE > $OUTFILE 2>&1 &
  background=$!
#  echo "   Launched $background" 1>&2
  exec 1>$INPIPE
#  echo "   Redirected this script's stdout to $INPIPE" 1>&2

  while [ 1 ]; do
    sleep 1
    ps -p $background > /dev/null
    [ $? -ne 0 ] && break

    if [ -s $INFILE ]; then
      line=`head -n 1 $INFILE`
      case `echo "$line"|awk '{print $1}'` in
        reset)  echo "        Resetting process $background" 1>&2; echo "q";;
         stop)  echo "        Stopping process $background" 1>&2; echo "q"; run=0; break;;
            *)  echo "        Relaying to process $background" 1>&2; echo "$line";;
      esac
      /bin/echo -n "" > $INFILE
    fi

  done

  echo "   Background task disappeared!" 1>&2
  rm $INPIPE
  rm $INFILE
  rm $OUTFILE
  echo "   Cleaned up all files." 1>&2 
done
sleep 3
echo "----------------------------------------------------------------" 1>&2
echo "Shutdown was orderly" 1>&2
