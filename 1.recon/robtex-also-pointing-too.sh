#!/bin/bash
if [ -z $1 ];then printf "\nSyntax: $0 <ip|23.239.11.30>\n\n"
echo "To automate:
$ bash arin-recon.sh '*example*'|grep CIDR|awk '{print $2}'|sort -u > /tmp/targets.txt
$ for CIDR in \`< /tmp/targets.txt\`; do for IP in \`python ../subnet2ip.py $CIDR\`; do bash robtex-also-pointing-too.sh $IP; sleep .1; done;done
"

	else
IP=$1
RES=`curl -A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36' -s https://www.robtex.com/ip-lookup/$IP | grep "Pointing to the IP number"`
if [ $? == 0 ];then
	for LINE in `echo $RES|egrep -o '>[^>]+<'|grep -v Pointing|sed 's/[><]//g;'|sort -u`; do
		echo "$IP - $LINE";
	done
fi
fi
