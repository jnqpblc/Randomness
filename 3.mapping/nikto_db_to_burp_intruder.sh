#!/bin/bash
# nikto_db_to_burp_intruder.sh - Converts the nikto database into a list.
# v0.01 2015/04/03
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

awk -F "," '{print $4}' nikto/program/databases/db_tests|egrep -v '^"@'|egrep '^"'|sort -u|sed 's/^"//g; s/"$//g' > nikto-list-burp-intruder.lst;
for var in $(egrep '^@' nikto/program/databases/db_variables|cut -d'=' -f1); do
   for path in $(egrep "^$var" nikto/program/databases/db_variables|cut -d'=' -f2); do
      escpath=$(echo $path|sed 's/\//\\\//g'); awk -F "," '{print $4}' nikto/program/databases/db_tests|grep "$var"|sed "s/$var/$escpath/"|sed 's/^"//g; s/"$//g' >> nikto-list-burp-intruder.lst;
   done
done;
