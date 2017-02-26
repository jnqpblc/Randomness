#!/bin/bash
# http://sourceforge.net/projects/dirb/files/
if [ -z $1 ]; then printf "\nSytnax: $0 <client>\n\n"
	else
CLIENT=$1; for TARGET in $(grep -l 'Target IP' ~/$CLIENT/nikto-output-*.txt|sort -u|awk -F- '{print $4":"$5":"$6}'); do
   HOST=$(echo $TARGET|cut -d':' -f1); PORT=$(echo $TARGET|cut -d':' -f2); PROTO=$(echo $TARGET|cut -d':' -f3);
   if [ "$PROTO" == "ssl.txt" ];then
      echo "dirb https://$HOST:$PORT/ /usr/share/wordlists/dirb/big.txt -o ~/$CLIENT/dirb-output-$HOST-$PORT-https.txt -r"
      dirb https://$HOST:$PORT/ /usr/share/wordlists/dirb/big.txt -o ~/$CLIENT/dirb-output-$HOST-$PORT-https.txt -r
   elif [ "$PROTO" == "nossl.txt" ];then
      echo "dirb http://$HOST:$PORT/ /usr/share/wordlists/dirb/big.txt -o ~/$CLIENT/dirb-output-$HOST-$PORT-http.txt -r"
      dirb http://$HOST:$PORT/ /usr/share/wordlists/dirb/big.txt -o ~/$CLIENT/dirb-output-$HOST-$PORT-http.txt -r
   else
	echo "Dammit Bobby. $TARGET is a failure."
   fi
   done
fi
