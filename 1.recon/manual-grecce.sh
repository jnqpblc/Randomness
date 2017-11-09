#!/bin/bash

if [ -z $1 ];then printf "\nSyntax $0 <domain> <-s sites.txt|-e extensions.txt|-g bishopfox-google-queries.txt|-q general query against the domain>\n\n"
	else

domain="$1"

if [ $2 == '-s' ];then
	for site in $(cat "$3");do
		url="$part&q=%22*@$domain%22+site:$site"
		/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome "https://www.google.com/search?q=%22*@$domain%22+site:$site&num=100&client=safari&rls=en&filter=0"
		wait
		sleep .3;
	done

elif [ $2 == '-e' ];then
	for ext in $(cat "$3");do
		url="$part&q=site:$domain+ext:$ext"
		open "https://www.google.com/search?q=site:$domain+ext:$ext&num=100&client=safari&rls=en&filter=0"
		sleep .3;
	done

elif [ $2 == '-g' ];then
	printf "[!]\n[!] Warning: This is going to take about 12 hours.\n[!]\n"
	IFS=$'\n'; for dork in $(cat $3 | cut -d';' -f5 2>/dev/null | LC_ALL='C' sort -u); do
		encoded=$(echo "$dork" | php -r "echo urlencode(fgets(STDIN));"| sed 's/%0A//g');
		url="$part&q=site:$domain+$encoded"
		open "https://www.google.com/search?q=site:$domain+$encoded&num=100&client=safari&rls=en&filter=0"
		sleep .3;
	done

elif [ $2 == '-q' ];then
	url="$part&q=site:$domain+"$3""
	sleep .3;
	open "https://www.google.com/search?q=site:$domain+"$3"&num=100&client=safari&rls=en&filter=0"

else
	printf '\nDammit bobby.\n\n'

fi
fi
