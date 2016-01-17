#!/bin/bash
# git clone https://github.com/iSECPartners/sslyze.git
if [ -z $2 ]; then printf "\nSytnax: $0 <massscan.out> <client>\n\n"
	else
FILE=$1; CLIENT=$2; for HOST in $(awk '{print $6}' $FILE|sort -u); do
   for PORT in $(grep "$HOST" $FILE|awk '{print $4}'|cut -d'/' -f1;); do
      echo "python sslyze-0_11-linux64/sslyze/sslyze.py --timeout=1 --starttls=auto --regular --certinfo=full --chrome_sha1 $HOST:$PORT | tee  ~/$CLIENT/sslyze-output-$HOST-$PORT.txt"
      python sslyze-0_11-linux64/sslyze/sslyze.py --timeout=1 --starttls=auto --regular --certinfo=full --chrome_sha1 $HOST:$PORT | tee  ~/$CLIENT/sslyze-output-$HOST-$PORT.txt
      done
   done
fi
