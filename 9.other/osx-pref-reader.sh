#!/bin/bash
if [ -z $1 ];then printf "\nSyntax: $0 <list|read|all|full> <optional|preference name|read only>\n\n"
	else
	if [ $1 == 'list' ];then
		find /Library/Preferences -type f -name '*.plist'|cut -d'/' -f4|grep '\.plist'
	elif [ $1 == 'read' ];then
		ls -1 /Library/Preferences/$2 >/dev/null 2>&1
		if [ $? == '0' ];then
			defaults read /Library/Preferences/$2
		else
			echo 'Dammit Bobby. Check your pref name.'
		fi
        elif [ $1 == 'all' ];then
		for PREF in $(find /Library/Preferences -type f -name '*.plist'|cut -d'/' -f4|grep '\.plist'); do
			echo "$(hostname):$PWD $USER# bash osx-pref-reader.sh read $PREF"; defaults read /Library/Preferences/$PREF; printf '\n\n';
		done | less
        elif [ $1 == 'full' ];then
		IFS=$'\n';
		for PREF in $(find /Library -type f -name '*.plist'); do
			echo "$(hostname):$PWD $USER# defaults read $PREF"; defaults read "$PREF"; printf '\n\n';
		done | less

	else
		echo 'Dammit Bobby. list or read options only.'
	fi
fi
