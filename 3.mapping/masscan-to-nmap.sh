#!/bin/bash
# https://nmap.org/book/inst-source.html
# apt-get install autoconf -y; svn co https://svn.nmap.org/nmap/; cd nmap/; ./configure; make;
if [ -z $2 ]; then printf "\nSytnax: $0 <massscan.out> <client>\n\n"
	else
FILE=$1; CLIENT=$2; for HOST in $(awk '{print $6}' $FILE|sort -u -r); do
   PORTS=$(grep "$HOST " $FILE|awk '{print $4}'|cut -d'/' -f1|tr '\n' ','|sort -u|sed 's/,$//g';);
   echo "sudo ~/nmap/nmap -PN -sSV -p $PORTS --script 'ALL and not (broadcast or dos or fuzzer)' --script-args Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp) --open -oA ~/$CLIENT/nmap-output-$HOST $HOST"
   sudo ~/nmap/nmap -PN -sSV -p $PORTS --script 'ALL and not (broadcast or dos or fuzzer)' --script-args "Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)" --open -oA ~/$CLIENT/nmap-output-$HOST $HOST
   done
fi
