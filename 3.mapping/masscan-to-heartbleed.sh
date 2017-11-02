#!/bin/bash
# https://nmap.org/book/inst-source.html
# apt-get install autoconf -y; svn co https://svn.nmap.org/nmap/; cd nmap/; ./configure; make;
if [ -z $2 ]; then printf "\nSytnax: $0 <massscan.out> <client>\n\n"
	else
FILE=$1; CLIENT=$2; for HOST in $(awk '{print $6}' $FILE|sort -u); do
   PORTS=$(grep "$HOST " $FILE|awk '{print $4}'|cut -d'/' -f1|tr '\n' ','|sort -u|sed 's/,$//g';);
   echo "sudo nmap -d -Pn -sT -p $PORTS --open --script +ssl-heartbleed -oN ~/$CLIENT/nmap-output-heartbleed-$HOST $HOST"
   sudo nmap -d -Pn -sT -p $PORTS --open --script +ssl-heartbleed -oN ~/$CLIENT/nmap-output-heartbleed-$HOST $HOST
   done
fi
