#!/bin/bash
if [ -z $2 ]; then printf "\nSyntax: $0 <masscan-output.txt> <format|summary|csv>\n\n"
else
  if [ $2 == "summary" ]; then
    printf "\nMasscan found $(sort -k 6 $1|wc -l) open TCP ports across $(sort -k 6 $1|awk '{print $6}'|sort -u|wc -l) hosts within scope.\n\n"
    for ip in $(awk '{print $6}' $1|sort -u); do
      printf "$ip : "; egrep " $(echo $ip|sed 's/\./\\./g;') " $1|awk '{print $4}'|sort -n|tr '\n' ' ';
      printf '\n';
    done
    elif [ $2 == "csv" ]; then
    for ip in $(awk '{print $6}' $1|sort -u); do
      printf "$ip,"; egrep "$(echo $ip|sed 's/\./\\./g;')" $1|awk '{print $4}'|sort -n|tr '\n' ','|sed 's/,$//g;';
    done
  else
    printf "\nSyntax: $0 <masscan-output.txt> <format|summary|csv>\n\n"
  fi
fi
