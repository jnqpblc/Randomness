#!/bin/bash
# git clone https://github.com/sullo/nikto.git
if [ -z $2 ]; then printf "\nSytnax: $0 <massscan.out> <client>\n\n"
	else
FILE=$1; CLIENT=$2; for host in $(awk '{print $6}' $FILE|sort -u); do
   for PORT in $(grep "$HOST" $FILE|awk '{print $4}'|cut -d'/' -f1;); do
      echo "perl ~/nikto/program/nikto.pl -nossl -host http://$HOST:$PORT/ -F htm -output ~/$CLIENT/nikto-output-$HOST-$PORT-nossl.html|tee  ~/$CLIENT/nikto-output-$HOST-$PORT-nossl.txt"
      perl ~/nikto/program/nikto.pl -nossl -host http://$HOST:$PORT/ -F htm -output ~/$CLIENT/nikto-output-$HOST-$PORT-nossl.html|tee  ~/$CLIENT/nikto-output-$HOST-$PORT-nossl.txt
      echo "perl ~/nikto/program/nikto.pl -ssl -host https://$HOST:$PORT/ -F htm -output ~/$CLIENT/nikto-output-$HOST-$PORT-ssl.html|tee  ~/$CLIENT/nikto-output-$HOST-$PORT-ssl.txt"
      perl ~/nikto/program/nikto.pl -ssl -host https://$HOST:$PORT/ -F htm -output ~/$CLIENT/nikto-output-$HOST-$PORT-ssl.html|tee  ~/$CLIENT/nikto-output-$HOST-$PORT-ssl.txt
      done
   done
fi
