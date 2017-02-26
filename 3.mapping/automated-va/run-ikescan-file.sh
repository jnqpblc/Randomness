#!/bin/bash
if [ -z $3 ];then printf "\nSyntax: ./$0 <client> <file|~/client/targets> <Option|-i or -a or -t\n\n"
	else
CLIENT=$1
if [ $3 == '-i' ];then
	sudo ike-scan -M -f $2 | tee ~/$CLIENT/ikescan-output-file-main-mode.txt
elif [ $3 == '-a' ];then
	sudo ike-scan -M -A --id=GroupVPN -f $2 | tee ~/$CLIENT/ikescan-output-file-aggressive-mode.txt
elif [ $3 == '-t' ];then
	bash generate-transforms.sh | xargs --max-lines=8 sudo ike-scan -f $2 | grep Handshake| tee ~/$CLIENT/ikescan-output-file-generate-transforms.txt
else
	echo 'Dammit Bobby.'
fi
fi
