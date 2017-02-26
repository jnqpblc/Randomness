#!/bin/bash
if [ -z $1 ];then printf "\nSyntax: $0 <client>\n\n"
	else
CLIENT=$1;
cat -A ~/$CLIENT/whatweb-output-*.txt|sed 's/[0-9]\{1,2\}m//g; s/\^//g; s/[\]]\{1,10\}/\]/g; s/[\[]\{1,10\}/\[/g; s/\[\]/\]/g; s/^ \[//g; s/\[,/,/g; s/\$//g;'|egrep -o '[0-9a-zA-Z]+\[[^]]+\]'|sort|uniq -c|sort -n > ~/$CLIENT/counted.whatweb
echo "Export created."
ls -l ~/$CLIENT/counted.whatweb;
fi
