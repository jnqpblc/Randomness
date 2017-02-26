#!/bin/bash
if [ -z $1 ]; then printf "\nRun ./tcpTraceroute.sh, first to get the TTL of the last 0 TTL responce\nSyntax $0 1.2.3.4 80 13\n\n"
  else
ip=$(echo $1|awk -F "." '{print $1"."$2"."$3}')
for i in $(seq 208 220); do
    sudo hping3 -S -c 1 -n -t $3 -p $2 $ip.$i 2>&1 | grep 'ip=' | sed "s/^/$ip.$i\: /g"; sleep 1
  done
fi
