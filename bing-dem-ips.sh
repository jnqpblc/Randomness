#!/bin/bash
# bing-dem-ips.sh - Commandline IP Address Binger Tool
# v0.01 2015/01/15
#
# Copyright (C); 2014 jnqpblc - jnqpblc at gmail
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

if [ -z $1 ];then printf "\nSyntax: $0 <ip>\n\n"
	else

ua='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/600.3.18 (KHTML, like Gecko) Version/8.0.3 Safari/600.3.18'

printf "\n### $1\n"
curl -A "$ua" "http://www.bing.com/search?q=ip%3A$1&go=Submit" 2>/dev/null|grep 'h="ID=SERP'|tr '"' '\n'|egrep '^[a-z]{1,5}:\/\/'|egrep -v 'microsoft\.com'
printf '\n'
fi
