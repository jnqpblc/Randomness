#!/bin/bash
if [ -z $1 ];then printf "\nSyntax $0 <domain> <-s sites.txt|-e extensions.txt|-q general query against the domain>\n\n"
	else

domain="$1"
part='/ajax/services/search/web?v=1.0&rsz=large'

if [ $2 == '-s' ];then
	for site in $(cat "$3");do
		url="$part&q=%22*@$domain%22+site:$site"
		echo "##### https://www.google.com/search?q=%22*@$domain%22+site:$site&num=100&client=safari&rls=en&filter=0"
		curl -A '' -H 'Accept:' -H 'Referrer: http://www.secureworks.com/' "http://ajax.googleapis.com/$url" 2>/dev/null | tr ',' '\n'|egrep '^"url|^"cacheUrl|^"title|^"content'|sed -e 's/^"url/^"url/g; s/\\u00/%/g; s/"//g; s/%26/&/g; s/%3[Ff]/?/g; s/%3[Dd]/=/g;'|tr '^' '\n'
		sleep 7;
	done

elif [ $2 == '-e' ];then
	for ext in $(cat "$3");do
		url="$part&q=site:$domain+ext:$ext"
		echo "##### https://www.google.com/search?q=site:$domain+ext:$ext&num=100&client=safari&rls=en&filter=0"
		curl -A '' -H 'Accept:' -H 'Referrer: http://www.secureworks.com/' "http://ajax.googleapis.com/$url" 2>/dev/null | tr ',' '\n'|egrep '^"url|^"cacheUrl|^"title|^"content'|sed -e 's/^"url/^"url/g; s/\\u00/%/g; s/"//g; s/%26/&/g; s/%3[Ff]/?/g; s/%3[Dd]/=/g;'|tr '^' '\n'
		sleep 7;
	done

elif [ $2 == '-q' ];then
	url="$part&q=site:$domain+"$3""
	sleep 7;
	echo "##### https://www.google.com/search?q=site:$domain+"$3"&num=100&client=safari&rls=en&filter=0"
	curl -A '' -H 'Accept:' -H 'Referrer: http://www.secureworks.com/' "http://ajax.googleapis.com/$url" 2>/dev/null | tr ',' '\n'|egrep '^"url|^"cacheUrl|^"title|^"content'|sed -e 's/^"url/^"url/g; s/\\u00/%/g; s/"//g; s/%26/&/g; s/%3[Ff]/?/g; s/%3[Dd]/=/g;'|tr '^' '\n'

else
	printf '\nDammit bobby.\n\n'

fi
fi
