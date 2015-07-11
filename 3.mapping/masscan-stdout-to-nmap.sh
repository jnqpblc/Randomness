#!/bin/bash
if [ -z $2 ]; then printf "\nSytnax: $0 <massscan.out> <client>\n\n"
	else
FILE=$1; CLIENT=$2; for host in $(awk '{print $6}' $FILE|sort -u); do
   PORTS=$(grep "$HOST" $FILE|awk '{print $4}'|cut -d'/' -f1|tr '\n' ','|sed 's/,$//g';);
   echo "sudo nmap -PN -sSV -p $PORTS --script 'ALL and not (broadcast or dos or fuzzer)' --open -oA ~/$CLIENT/$HOST $HOST"
   sudo nmap -PN -sSV -p $PORTS --script 'ALL and not (broadcast or dos or fuzzer)' --open -oA ~/$CLIENT/$HOST $HOST
   done
fi
