#!/bin/bash
if [ -z $1 ];then printf "\nSyntax: $0 <client folder|~/example/>\n\n";
	else
cd $1
for ip in $(egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' masscan-output.txt|sort -u|sed 's/\./\\./g;'); do for file in $(find . -name "*$ip-*.txt" -o -name "*$ip.nmap"|sort -u); do cat $file;done|less -R;done
fi
