#!/bin/bash
if [ -z $1 ]; then printf "\nSyntax $0 <file|alive.txt>\n\n";
  else
for x in $(cat $1); do
	for y in $(echo 21 22 23 80 81 111 135 139 161 389 443 445 513 1433 2049 3306 5432 5800 5801 5900 5901 8080 8443); do
		nc -nvzw1 $x $y 2>&1 | grep succeeded;
done; done
fi
