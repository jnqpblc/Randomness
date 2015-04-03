#!/bin/bash
#!/usr/bin/env python
# the_real_whois_like_a_boss.sh - Commandline ARIN Advanced Query Tool
# v0.02 2015/01/15
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

arinr=$(ls -1 arinr/bin/arininfo 2>&1|grep -v 'No such file or directory');
if [ -z $arinr ];then
	printf "\nYou need this tool.\ngit clone http://anon:anon@stash-projects.arin.net:7990/scm/ARINR/arinr.git\n\n"

else	
	if [ -z $1 ];then printf "\nSyntax: bash $0 '*query*'\nSyntax: bash $0 '*query*with*spaces*'\n\n"

	else

query=$1

printf "Strating ARIN advaned whois query via orgname..."
file=$(date +"%Y%m%d_%H%M%S"_ARININFO_StarSearch.txt);
echo '# Delete any organization that is out of scope, E.g. DEL = Ctrl+k, EXIT = Crtl+x' > $file
arinr/bin/arininfo -t orgname "$query"|egrep '[0-9]{1,4}\=' >> $file;
echo "Done"

nano $file

printf "Starting ARIN org enumeration via the orghandle..."
file=$(date +"%Y%m%d_%H%M%S"_ARININFO_Enumeration.txt);
for entry in $(egrep '[0-9]{1,4}\=' *_ARININFO_StarSearch.txt|cut -d'(' -f2|cut -d')' -f1); do
	arinr/bin/arininfo --data extra -t orghandle $entry >> $file;
	printf '.';
	done
echo "Done"

printf "Starting ARIN network enumeration via the nethandle..."
file=$(date +"%Y%m%d_%H%M%S"_ARININFO_Networks.txt);
for netname in $(egrep '= NET[6]?-' *_ARININFO_Enumeration.txt|awk '{print $3}'); do
	arinr/bin/arininfo --data extra -t nethandle $netname >> $file;
	printf '.';
	done
echo "Done"

printf "Parsing out CIDR networks into separate file..."
file=$(date +"%Y%m%d_%H%M%S"_ARININFO_CIDRs.txt);
grep CIDR *_ARININFO_Networks.txt|awk '{print $2}' > $file
echo "Done"

printf "Counting networks, grouped by CIDR..."
file=$(date +"%Y%m%d_%H%M%S"_ARININFO_CIDRs_Count.txt);
for cidr in $(cat *_ARININFO_CIDRs.txt|cut -d'/' -f2|sort -u); do
	printf "/$cidr: ";egrep "/$cidr$" *_ARININFO_CIDRs.txt|wc -l;
	done > $file
echo "Done"

echo
cat $file
echo
ls -1 *ARININFO*
echo

fi
fi
