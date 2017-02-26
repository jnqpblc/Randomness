#!/bin/bash
# git clone https://github.com/wpscanteam/wpscan.git
if [ -z $1 ]; then printf "\nSytnax: $0 <client>\n\n"
	else
CLIENT=$1; for TARGET in $(grep -l 'Target IP' ~/$CLIENT/nikto-output-*.txt|sort -u|awk -F- '{print $3":"$4":"$5}'); do
   HOST=$(echo $TARGET|cut -d':' -f1); PORT=$(echo $TARGET|cut -d':' -f2); PROTO=$(echo $TARGET|cut -d':' -f3);
   if [ "$PROTO" == "ssl.txt" ];then
      echo "ruby ~/wpscan/wpscan.rb --url https://$HOST:$PORT/ | tee ~/$CLIENT/wpscan-output-$HOST-$PORT-https.txt"
      sudo wpscan --random-agent --url https://$HOST:$PORT/ | tee ~/$CLIENT/wpscan-output-$HOST-$PORT-https.txt
   elif [ "$PROTO" == "nossl.txt" ];then
      echo "ruby ~/wpscan/wpscan.rb --url http://$HOST:$PORT/ | tee ~/$CLIENT/wpscan-output-$HOST-$PORT-http.txt"
      sudo wpscan --random-agent --url http://$HOST:$PORT/ | tee ~/$CLIENT/wpscan-output-$HOST-$PORT-http.txt
   else
	echo "Dammit Bobby. $TARGET is a failure."
   fi
   done
fi
