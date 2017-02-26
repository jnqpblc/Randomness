#!/bin/bash
# git clone https://github.com/nabla-c0d3/sslyze.git; cd sslyze; pip install -r requirements.txt --target ./lib
if [ -z $2 ]; then printf "\nSytnax: $0 <massscan.out> <client>\n\n"
	else
FILE=$1; CLIENT=$2; CMD=$(find ~/ -type f -name sslyze.py|head -1); for HOST in $(awk '{print $6}' $FILE|sort -u); do
   for PORT in $(grep "$HOST" $FILE|awk '{print $4}'|cut -d'/' -f1;); do
      echo "python $CMD --timeout=1 --starttls=auto --regular --certinfo=full $HOST:$PORT | tee  ~/$CLIENT/sslyze-output-$HOST-$PORT.txt"
      python $CMD --timeout=1 --starttls=auto --regular --certinfo=full $HOST:$PORT | tee  ~/$CLIENT/sslyze-output-$HOST-$PORT.txt
      done
   done
fi
