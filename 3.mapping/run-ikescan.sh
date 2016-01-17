#!/bin/bash
if [ -z $2 ];then printf "\nSyntax: ./$0 <client> <ip|1.1.1.1> <Option|-i or -a or -t>\n\n"
	else
CLIENT=$1
if [ $3 == '-i' ];then
	sudo ike-scan -M $2 | tee ~/$CLIENT/ikescan-output-$2-main-mode.txt
elif [ $3 == '-a' ];then
	sudo ike-scan -M -A --id=GroupVPN $2 | tee ~/$CLIENT/ikescan-output-$2-aggressive-mode.txt
elif [ $3 == '-t' ];then
	bash generate-transforms.sh | xargs --max-lines=8 sudo ike-scan $2 | grep Handshake| tee ~/$CLIENT/ikescan-output-$2-generate-transforms.txt
else
	echo 'Dammit Bobby.'
fi
fi
