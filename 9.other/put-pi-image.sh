#!/bin/bash
if [ -z $3 ];then printf "\nSyntax: $0 pi-backup.img.gz <gz|none|zip> /dev/rdisk42\n\n"
	else
	if [ $2 == 'gz' ];then
		diskutil unmountDisk $3; gzip -dc $1 | sudo dd of=$3 bs=4m
	elif [ $2 == 'none' ];then
		diskutil unmountDisk $3; sudo dd if=$1 of=$3 bs=4m
	elif [ $2 == 'zip' ];then
		diskutil unmountDisk $3; unzip -p $1 | sudo dd of=$3 bs=4m
	else printf '\nDammit Bobby. Stop being stoooopid.\n\n'
	fi
fi
