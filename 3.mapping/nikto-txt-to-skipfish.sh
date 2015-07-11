#!/bin/bash
# https://www.owasp.org/index.php/Automated_Audit_using_SKIPFISH
if [ -z $1 ]; then printf "\nSytnax: $0 <client>\n\n"
	else
CLIENT=$1; URI_TO_IGNORE='/css/,/img/,/images/,/js/,/doc/'; SUPP_DICT='/usr/share/skipfish/dictionaries/extensions-only.wl'
for TARGET in $(grep -l 'Target IP' ~/$CLIENT/nikto-output-*.txt|sort -u|awk -F- '{print $3":"$4":"$5}'); do
   HOST=$(echo $TARGET|cut -d':' -f1); PORT=$(echo $TARGET|cut -d':' -f2); PROTO=$(echo $TARGET|cut -d':' -f3);
   if [ "$PROTO" == "ssl.txt" ];then
      REPORT_DIR=~/$CLIENT/skipfish-report-$HOST-$PORT-https/; TARGET_URL=https://$HOST:$PORT/;
      CUSTOM_DICT=~/$CLIENT/skipfish-$HOST-$PORT-https.dict;
      if [ -d $REPORT_DIR ];then
         rm -rf $REPORT_DIR
      fi
      if [ ! -f $CUSTOM_DICT ];then
         touch $CUSTOM_DICT
      fi
      skipfish -b i -X $URI_TO_IGNORE -Z -o $REPORT_DIR -M -Q -S $SUPP_DICT -W $CUSTOM_DICT -Y -R 5 -G 256 -l 3 -g 10 -m 10 -f 20 -t 60 -w 60 -i 60 -s 1024000 -e $TARGET_URL
   elif [ "$PROTO" == "nossl.txt" ];then
      REPORT_DIR=~/$CLIENT/skipfish-report-$HOST-$PORT-http/; TARGET_URL=http://$HOST:$PORT/;
      CUSTOM_DICT=~/$CLIENT/skipfish-$HOST-$PORT-http.dict;
      if [ -d $REPORT_DIR ];then
         rm -rf $REPORT_DIR
      fi
      if [ ! -f $CUSTOM_DICT ];then
         touch $CUSTOM_DICT
      fi
      skipfish -b i -X $URI_TO_IGNORE -Z -o $REPORT_DIR -M -Q -S $SUPP_DICT -W $CUSTOM_DICT -Y -R 5 -G 256 -l 3 -g 10 -m 10 -f 20 -t 60 -w 60 -i 60 -s 1024000 -e $TARGET_URL
   else
	echo "Dammit Bobby. $target is a failure."
   fi
   done
fi
