#!/bin/bash
# googlepie-recon.sh - Commandline Google Search Tool
# v0.02 2015/09/03
#
# Copyright (C); 2015 jnqpblc - jnqpblc at gmail
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option); any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [ -z $1 ];then printf "\nSyntax $0 <domain> <-s sites.txt|-e extensions.txt|-g bishopfox-google-queries.txt|-q general query against the domain>\n\n"
	else

domain="$1"
part='ajax/services/search/web?v=1.0&rsz=large'

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

elif [ $2 == '-g' ];then
	printf "[!]\n[!] Warning: This is going to take about 12 hours.\n[!]\n"
	IFS=$'\n'; for dork in $(cat $3 | cut -d';' -f5 2>/dev/null | LC_ALL='C' sort -u); do
		encoded=$(echo "$dork" | php -r "echo urlencode(fgets(STDIN));"| sed 's/%0A//g');
		url="$part&q=site:$domain+$encoded"
		echo "##### https://www.google.com/search?q=site:$domain+$encoded&num=100&client=safari&rls=en&filter=0"
		curl -A '' -H 'Accept:' -H 'Referrer: http://www.secureworks.com/' "http://ajax.googleapis.com/$url" 2>/dev/null | tr ',' '\n'|egrep '^"url|^"cacheUrl|^"title|^"content'|sed -e 's/^"url/^"url/g; s/\\u00/%/g; s/"//g; s/%26/&/g; s/%3[Ff]/?/g; s/%3[Dd]/=/g;'|tr '^' '\n'
		sleep 27;
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
