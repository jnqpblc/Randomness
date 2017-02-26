#!/bin/bash
if [ -z $2 ]; then printf "\nSytnax: $0 <massscan.out> <client>\n\n"
	else
FILE=$1; CLIENT=$2; cd ~/whatweb/; for HOST in $(awk '{print $6}' $FILE|sort -u); do
   for PORT in $(grep "$HOST" $FILE|awk '{print $4}'|cut -d'/' -f1;); do
      echo "ruby whatweb -a 4 --no-errors http://$HOST:$PORT/ 2>/dev/null|sed 's/\],/\],#/g'|tr '#' '\n' | tee ~/$CLIENT/whatweb-output-$HOST-$PORT-http.txt"
      ruby whatweb -a 4 --no-errors http://$HOST:$PORT/ 2>/dev/null|sed 's/\],/\],#/g'|tr '#' '\n' | tee ~/$CLIENT/whatweb-output-$HOST-$PORT-http.txt
      echo "ruby whatweb -a 4 --no-errors https://$HOST:$PORT/ 2>/dev/null|sed 's/\],/\],#/g'|tr '#' '\n' | tee ~/$CLIENT/whatweb-output-$HOST-$PORT-https.txt"
      ruby whatweb -a 4 --no-errors https://$HOST:$PORT/ 2>/dev/null|sed 's/\],/\],#/g'|tr '#' '\n' | tee ~/$CLIENT/whatweb-output-$HOST-$PORT-https.txt
      done
   done
fi
