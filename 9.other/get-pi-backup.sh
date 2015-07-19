#!/bin/bash
if [ -z $2 ];then printf "\nSyntax: $0 /dev/rdisk42 pi-backup-8G\n\n"
	else
sudo dd if=$1 bs=4m | gzip -cf > $2.img.gz
fi
