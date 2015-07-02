#!/bin/bash
if [ -z $1 ]; then printf "\nSyntax $0 1.1.1.1 80\n\n"
  else
for i in $(seq 1 20); do
    sudo hping3 -S -c 1 -n -t $i -p $2 $1 2>&1 | grep 'ip=' | sed "s/^/$i /g";
  done
fi
