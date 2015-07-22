#!/bin/bash
if [ -z $3 ];then printf "\nSyntax: $0  <client> <proto> <file with tagets> <os> <web language>\n\n"
	else
		if [ -z $4 ];then OS="unknown"; LANG="unknown";
			w3af-it;
			exit 0;
		else
			OS=$4; LANG=$5;	
			w3af-it;
			exit 0;
		exit 0;
		fi

	w3af-it() {
	CLIENT=$1; PROTO=$2; FILE=$3;
	for TARGET in $(cat "$FILE"); do
		cat w3af_automate_template.w3af|sed "s/{CLIENT}/$CLIENT/g; s/{PROTO}/$PROTO/g; s/{TARGET}/$TARGET/g; s/{OS}/$OS/g; s/{LANG}/$LANG/g;" > "~/$CLIENT/w3af_automate_$TARGET.w3af";
		w3af_console -s "~/$CLIENT/w3af_automate_$TARGET.w3af";
	done
	}
fi
