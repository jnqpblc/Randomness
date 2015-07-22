#!/bin/bash
if [ -z $4 ];then printf "\nSyntax: $0  <client> <file with tagets> <os> <web language>\n\n"
	else
CLIENT=$1; PROTO=$2; FILE=$3;
for TARGET in $(cat "$FILE"); do
	cat w3af_automate_template.w3af|sed "s/{CLIENT}/$1/g; s/{TARGET}/$target/g; s/{OS}/$3/g; s/{LANG}/$4/g;" > "~/$CLIENT/w3af_automate_$TARGET.w3af";;
	w3af_console -s "~/$CLIENT/w3af_automate_$TARGET.w3af";
done
fi
