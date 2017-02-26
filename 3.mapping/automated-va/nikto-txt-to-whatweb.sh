#!/bin/bash
if [ -z $1 ]; then printf "\nSytnax: $0 <client>\n\n"
	else
CLIENT=$1; for TARGET in $(grep -l 'Target IP' ~/$CLIENT/nikto-output-*.txt|sort -u|awk -F- '{print $3":"$4":"$5}'); do
   HOST=$(echo $TARGET|cut -d':' -f1); PORT=$(echo $TARGET|cut -d':' -f2); PROTO=$(echo $TARGET|cut -d':' -f3);
   if [ "$PROTO" == "ssl.txt" ];then
      echo "whatweb -a 4 --no-errors https://$HOST:$PORT/ 2>/dev/null|sed 's/\],/\],#/g'|tr '#' '\n' | tee ~/$CLIENT/whatweb-output-$HOST-$PORT-https.txt"
      whatweb -a 4 --no-errors https://$HOST:$PORT/ 2>/dev/null|sed 's/\],/\],#/g'|tr '#' '\n' | tee ~/$CLIENT/whatweb-output-$HOST-$PORT-https.txt
   elif [ "$PROTO" == "nossl.txt" ];then
      echo "whatweb -a 4 --no-errors http://$HOST:$PORT/ 2>/dev/null|sed 's/\],/\],#/g'|tr '#' '\n' | tee ~/$CLIENT/whatweb-output-$HOST-$PORT-http.txt"
      whatweb -a 4 --no-errors http://$HOST:$PORT/ 2>/dev/null|sed 's/\],/\],#/g'|tr '#' '\n' | tee ~/$CLIENT/whatweb-output-$HOST-$PORT-http.txt
   else
	echo "Dammit Bobby. $TARGET is a failure."
   fi
   done
fi
