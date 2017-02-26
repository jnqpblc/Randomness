#!/bin/bash
if [ -z $1 ]; then printf "\nSyntax: $0 <masscan-output.txt>\n\n"
	else
printf "\nMasscan found $(sort -k 6 $1|wc -l) open TCP ports across $(sort -k 6 $1|awk '{print $6}'|sort -u|wc -l) hosts within scope.\n\n"
for ip in $(awk '{print $6}' $1|sort -u); do
	printf "$ip : "; egrep " $(echo $ip|sed 's/\./\\./g;') " $1|awk '{print $4}'|sort -n|tr '\n' ' ';
	printf '\n';
done
fi
