#!/bin/bash

if [ -z $4 ];then printf "\nSyntax $0 <domain> <size|25> <-s sites.txt|-e extensions.txt|-g bishopfox-google-queries.txt|-q general query against the domain>\n\n"
	else

DOMAIN="$1"
SIZE="$2"
SWITCH="$3"
INPUT="$4"
COUNT=`wc -l $INPUT|awk '{print $1}'`

if [ $SWITCH == '-s' ];then
	for (( i=0; i<=$COUNT; i+=$SIZE )); do
	for site in $(head -n $i $INPUT | tail -n $SIZE);do
		url="$part&q=%22*@$DOMAIN%22+site:$site"
		open "https://www.google.com/search?q=%22*@$DOMAIN%22+site:$site&num=100&client=safari&rls=en&filter=0"
		sleep .3;
	done;
	read -p "Press any key to continue";
	done

elif [ $SWITCH == '-e' ];then
	for (( i=0; i<=$COUNT; i+=$SIZE )); do
	for ext in $(head -n $i $INPUT | tail -n $SIZE);do
		url="$part&q=site:$DOMAIN+ext:$ext"
		open "https://www.google.com/search?q=site:$DOMAIN+ext:$ext&num=100&client=safari&rls=en&filter=0"
		sleep .3;
	done;
	read -p "Press any key to continue";
	done

elif [ $SWITCH == '-g' ];then
	printf "[!]\n[!] Warning: This is going to take about 12 hours.\n[!]\n"
	for (( i=0; i<=$COUNT; i+=$SIZE )); do
	IFS=$'\n'; for dork in $(head -n $i $INPUT | tail -n $SIZE | cut -d';' -f5 2>/dev/null | LC_ALL='C' sort -u); do
		encoded=$(echo "$dork" | php -r "echo urlencode(fgets(STDIN));"| sed 's/%0A//g');
		url="$part&q=site:$DOMAIN+$encoded"
		open "https://www.google.com/search?q=site:$DOMAIN+$encoded&num=100&client=safari&rls=en&filter=0"
		sleep .3;
	done;
	read -p "Press any key to continue";
	done

elif [ $SWITCH == '-q' ];then
	url="$part&q=site:$DOMAIN+"$INPUT""
	sleep .3;
	open "https://www.google.com/search?q=site:$DOMAIN+"$3"&num=100&client=safari&rls=en&filter=0"

else
	printf '\nDammit bobby.\n\n'

fi
fi
