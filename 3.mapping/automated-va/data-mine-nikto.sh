#!/bin/bash
if [ -z $1 ];then printf "\nSyntax: $0 <client>\n\n"
	else
CLIENT=$1;
egrep -h '^\+' ~/$CLIENT/nikto-output-*.txt|egrep -v 'No web server|End Time|Start Time|Target IP|Target Hostname|reported on remote host'|sort|uniq -c|sort -n > ~/$CLIENT/counted.nikto
echo "Export created."
ls -l ~/$CLIENT/counted.nikto;
fi
