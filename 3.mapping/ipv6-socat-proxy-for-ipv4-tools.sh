#!/bin/bash
# wget http://www.dest-unreach.org/socat/download/socat-2.0.0-b8.tar.gz
if [ -z $3 ]; then printf "\nSytnax: $0 <proxy-port> <ipv6-address> <port>\n\n"
	else
PROXY=$1; IPV6=$2; PORT=$3;
socat TCP-LISTEN:$PROXY,reuseaddr,fork TCP6:[$IPV6]:$PORT
fi
