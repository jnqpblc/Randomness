#!/bin/bash
if [ -z $4 ];then printf "\nSyntax: $0 <project> <file with tagets> <os> <web language>\n\n"
	else

for TARGET in $(cat "$2"); do
	cat w3af_automate_template.w3af|sed "s/{PROJECT}/$1/g; s/{TARGET}/$target/g; s/{OS}/$3/g; s/{LANG}/$4/g;" > $(pwd)/"$1"_"$TARGET"_w3af_automate.w3af;
	w3af_console -s $(pwd)/"$1"_"$TARGET"_w3af_automate.w3af;
done
fi
