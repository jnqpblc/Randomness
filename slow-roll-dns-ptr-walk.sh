#!/bin/bash
# slow-roll-dns-ptr-walk.sh - A reverse DNS lookup zone enumeration tool
# v0.01 2015/02/21
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

if [ -z $6 ]; then printf "\nSyntax: bash $0 <dns-server> <seconds-to-sleep> <subnet> <min-num> <max-num> <increment>\nSytnax: bash $0 8.8.8.8 3 10.10.10.0 0 255 1\n\n"

	else

srv=$1
time=$2
subnet=$(echo $3|awk -F. '{print $1"."$2"."$3}');
min=$4
max=$5
by=$6

for num in $(seq $min $by $max|awk 'BEGIN{srand()}{printf "%06d %s\n", rand()*1000000, $0;}'|sort -n|awk '{print $2}'); do
	host $subnet.$num $srv|grep ' name pointer '|awk '{print $1" "$5}'|sed 's/\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}.in-addr\.arpa//g'|sort -n|sed "s/^/$subnet\./g"|sed 's/\.$//g';
	sleep $time;
done

fi
