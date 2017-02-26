#!/bin/bash
# git clone https://github.com/robertdavidgraham/masscan.git
if [ -z $3 ]; then printf "\nSytnax: $0 <client> <file of ips> <rate|e.g. 1000>\n\n"
	else
   CLIENT=$1; FILE=$2; RATE=$3;
   echo "~/masscan/bin/masscan -iL $FILE --ports T:0-65535 --rate $RATE --banners -oB ~/$CLIENT/masscan-output.bin --interface eth0"
   sudo ~/masscan/bin/masscan -iL $FILE --ports T:0-65535 --rate $RATE --banners -oB ~/$CLIENT/masscan-output.bin --interface eth0|tee ~/$CLIENT/masscan-output.txt
   check=$(ls ~/$CLIENT/masscan-output.bin > /dev/null 2>&1); if [ $? -eq 0 ];then
      ~/masscan/bin/masscan --open --banners --readscan ~/$CLIENT/masscan-output.bin -oX ~/$CLIENT/masscan-output.xml
      ~/masscan/bin/masscan --readscan ~/$CLIENT/masscan-output.bin > ~/$CLIENT/masscan-output.txt
   fi
fi
