#!/bin/bash
if [ -z $4 ];then printf "\nSyntax: $0  <client> <file with tagets> <os> <web language>\n\n"
	else

for TARGET in $(cat "$2"); do
	cat w3af_automate_template.w3af|sed "s/{CLIENT}/$1/g; s/{TARGET}/$target/g; s/{OS}/$3/g; s/{LANG}/$4/g;" > ~/$1/w3af_automate_"$TARGET".w3af;
	w3af_console -s ~/$1/w3af_automate_"$TARGET".w3af;
done
fi
