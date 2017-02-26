#!/bin/bash
# git clone https://github.com/sqlmapproject/sqlmap.git
if [ -z $1 ]; then printf "\nSytnax: $0 <client>\n\n"
	else
CLIENT=$1; cd ~/sqlmap/; for TARGET in $(grep -l 'Target IP' ~/$CLIENT/nikto-output-*.txt|sort -u|awk -F- '{print $4":"$5":"$6}'); do
   HOST=$(echo $TARGET|cut -d':' -f1); PORT=$(echo $TARGET|cut -d':' -f2); PROTO=$(echo $TARGET|cut -d':' -f3);
   if [ "$PROTO" == "ssl.txt" ];then
      echo "sqlmap --random-agent --forms --batch --smart --crawl=16 --level=4 --risk=2 -u https://$HOST:$PORT/ | tee ~/$CLIENT/sqlmap-output-$HOST-$PORT-https.txt"
      sqlmap --random-agent --forms --batch --smart --crawl=16 --level=4 --risk=2 -u https://$HOST:$PORT/ | tee ~/$CLIENT/sqlmap-output-$HOST-$PORT-https.txt
   elif [ "$PROTO" == "nossl.txt" ];then
      echo "sqlmap --random-agent --forms --batch --smart --crawl=16 --level=4 --risk=2 -u http://$HOST:$PORT/ | tee ~/$CLIENT/sqlmap-output-$HOST-$PORT-http.txt"
      sqlmap --random-agent --forms --batch --smart --crawl=16 --level=4 --risk=2 -u http://$HOST:$PORT/ | tee ~/$CLIENT/sqlmap-output-$HOST-$PORT-http.txt
   else
	echo "Dammit Bobby. $TARGET is a failure."
   fi
   done
fi
