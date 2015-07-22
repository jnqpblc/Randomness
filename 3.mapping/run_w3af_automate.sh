#!/bin/bash
if [ -z $3 ];then printf "\nSyntax: $0 <client> <proto> <file with tagets> <os> <web language>\n\n"
	else
		w3af-it() {
			for TARGET in $(cat "$FILE"); do
				cat "$(echo $0|sed 's/run_w3af_automate.sh//g')w3af_automate_template.w3af"|sed "s/{CLIENT}/$CLIENT/g; s/{PROTO}/$PROTO/g; s/{TARGET}/$TARGET/g; s/{OS}/$OS/g; s/{LANG}/$LANG/g;" > ~/$CLIENT/w3af-automate-$TARGET-$PROTO.w3af;
				w3af_console -s ~/$CLIENT/w3af-automate-$TARGET-$PROTO.w3af;
			done
		}
		if [ -z $4 ];then CLIENT="$1"; PROTO="$2"; FILE="$3"; OS="unknown"; LANG="unknown";
			w3af-it;
			exit 0;
		else
			CLIENT="$1"; PROTO="$2"; FILE="$3"; OS="$4"; LANG="$5";
			w3af-it;
			exit 0;
		exit 0;
		fi
fi
