#!/bin/bash
# https://nmap.org/book/inst-source.html
# apt-get install autoconf -y; svn co https://svn.nmap.org/nmap/; cd nmap/; ./configure; make;
if [ -z $2 ]; then printf "\nSytnax: $0 <massscan.out> <client>\n\n"
	else
FILE=$1; CLIENT=$2; for HOST in $(awk '{print $6}' $FILE|sort -u); do
   PORTS=$(grep "$HOST " $FILE|awk '{print $4}'|cut -d'/' -f1|tr '\n' ','|sort -u|sed 's/,$//g';);
   # $uag & $apikey are from "Randomness/0.setup/.bashrc"
   echo "sudo ~/nmap/nmap -PN -sSV -p $PORTS --script 'ALL and not (broadcast or dos or fuzzer)' --script-args $uag --script-args $apikey --open -oA ~/$CLIENT/nmap-output-$HOST $HOST"
   sudo ~/nmap/nmap -PN -sSV -p $PORTS --script 'ALL and not (broadcast or dos or fuzzer)' --script-args "$uag" --script-args "$apikey" --open -oA ~/$CLIENT/nmap-output-$HOST $HOST
   #sudo nmap -PN -sSV -p $PORTS --script 'ALL and not (broadcast or dos or fuzzer)' --script-args "$uag" --script-args "$apikey" --open -oA ~/$CLIENT/nmap-output-$HOST $HOST
   done
fi
