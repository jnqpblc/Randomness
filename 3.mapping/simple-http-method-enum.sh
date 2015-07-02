#!/bin/bash
if [ -z $3 ];then printf "\nSyntax: $0 <host|www.example.com> <port|80> <http|https>\n\n"
	else
for method in HEAD DELETE TRACE CONNECT OPTIONS PUT PROPFIND; do
		printf "\n~# Trying $method...\n"; echo "curl -k -I -X $method $3://$1:$2/"; curl -k -I -X $method $3://$1:$2/;
	done
fi
