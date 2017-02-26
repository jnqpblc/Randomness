#!/bin/bash
if [ -z $2 ]; then printf "\nSytnax: $0 <client> <file of ips>\n\n"
        else
CLIENT=~/$1; FILE=$2; DIR='/usr/share/nmap/scripts/';
ls "$CLIENT" > /dev/null 2>&1; if [ $? -ne '0' ];then printf "\nPlease create a folder for $CLIENT and move your targets file into it.\n\n"
	else
	SCRIPTS=$(grep portrule $DIR*.nse|grep '"udp"'|cut -d':' -f1|tr '/' '\n'|grep '\.nse'| sed ':a;N;$!ba;s/\n/,/g; s/,$//g; s/\.nse//g;');
	PORTS=$(grep portrule $DIR*.nse|grep '"udp"'|sed 's/[^0-9a-zA-Z]/\n/g'|egrep -o '^[0-9]{1,5}'|sort -uR|sed ':a;N;$!ba;s/\n/,/g; s/,$//g;');
	sudo ~/nmap/nmap -PN -sUV -p $PORTS --open --script $SCRIPTS -oA $CLIENT/nmap-known-udp-ports-2 -iL $FILE
	#sudo nmap -PN -sUV -p $PORTS --open --script $SCRIPTS -oA $CLIENT/nmap-known-udp-ports-2 -iL $FILE
	fi
fi
