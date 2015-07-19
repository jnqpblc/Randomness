#!/bin/bash
if [ -z $2 ];then printf "\nSyntax: bash $0 <username> <client-name>\n\n"
	else
    date=$(date +"%Y-%m-%d")
    ssh-keygen -t rsa -b 4096 -f $1-$2-$date.key -I $1.key -n $1 -C $1 -V +4
    mv $1-$2-$date.key.pub $1-$2-$date.crt
fi
