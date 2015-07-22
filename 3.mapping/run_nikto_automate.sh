#!/bin/bash
if [ -z $3 ];then printf "\nSyntax: $0 <client> <proto> <file with tagets>\n\n"
	else
CLIENT=$1; PROTO=$2; FILE=$3;
for TARGET in $(cat "$FILE"); do
	nikto -host $PROTO://TARGET | tee "~/$CLIENT/nikto_automate_$TARGET_$PROTO.txt"
done
fi
