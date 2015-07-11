#!/bin/bash
# git clone https://github.com/andresriancho/w3af.git
if [ -z $1 ]; then printf "\nSytnax: $0 <client>\n\n"
	else
CLIENT=$1; cd ~/w3af/; for TARGET in $(grep -l 'Target IP' ~/$CLIENT/nikto-output-*.txt|sort -u|awk -F- '{print $3":"$4":"$5}'); do
   HOST=$(echo $TARGET|cut -d':' -f1); PORT=$(echo $TARGET|cut -d':' -f2); PROTO=$(echo $TARGET|cut -d':' -f3);
   if [ "$PROTO" == "ssl.txt" ];then
      sed "s/{CLIENT}/$CLIENT/g; s/{PROTO}/https/g; s/{TARGET}/$HOST/g; s/{PORT}/$PORT/g;" ../owasp.w3af > ~/$CLIENT/w3af-input-$HOST-$PORT-https.w3af
      sudo w3af_console -s ~/$CLIENT/w3af-input-$HOST-$PORT-https.w3af
   elif [ "$PROTO" == "nossl.txt" ];then
      sed "s/{CLIENT}/$CLIENT/g; s/{PROTO}/http/g; s/{TARGET}/$HOST/g; s/{PORT}/$PORT/g;" ../owasp.w3af > ~/$CLIENT/w3af-input-$HOST-$PORT-http.w3af
      sudo w3af_console -s ~/$CLIENT/w3af-input-$HOST-$PORT-http.w3af
   else
	echo "Dammit Bobby. $TARGET is a failure."
   fi
   done
fi
