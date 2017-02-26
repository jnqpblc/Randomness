#!/bin/bash
# http://sourceforge.net/projects/dirb/files/
if [ -z $5 ]; then printf "\nSytnax: $0 <client> <http|https> <ip> <port> <iis|apache>\n\n"

	else

CLIENT=$1;PROTO=$2;HOST=$3;PORT=$4;SRV=$5;

APACHEWLD='/usr/share/dirb/wordlists/vulns/apache.txt,/usr/share/dirb/wordlists/vulns/axis.txt,/usr/share/dirb/wordlists/catala.txt,/usr/share/dirb/wordlists/vulns/cgis.txt,/usr/share/dirb/wordlists/vulns/tomcat.txt'
APACHEWLS='/usr/share/seclists/Discovery/Apache.fuzz.txt,/usr/share/seclists/Discovery/ApacheTomcat.fuzz.txt,/usr/share/seclists/Discovery/PHP.fuzz.txt,/usr/share/seclists/Discovery/PHP_CommonBackdoors.fuzz.txt'
IISWLD='/usr/share/dirb/wordlists/vulns/frontpage.txt,/usr/share/dirb/wordlists/vulns/iis.txt,/usr/share/dirb/wordlists/vulns/sharepoint.txt'
IISWLS='/usr/share/seclists/Discovery/IIS.fuzz.txt,/usr/share/seclists/Discovery/CGI_HTTP_POST_Windows.fuzz.txt,/usr/share/seclists/Discovery/Sharepoint.fuzz.txt,/usr/share/seclists/Discovery/Frontpage.fuzz.txt,/usr/share/seclists/Discovery/CGI_Microsoft.fuzz.txt'

if [ "$SRV" == "iis" ];then
		dirb $PROTO://$HOST:$PORT "$IISWLD" -o ~/$CLIENT/dirb-output-"$HOST"-"$PORT"-"$PROTO"-iis-d.txt;
		dirb $PROTO://$HOST:$PORT "$IISWLS" -o ~/$CLIENT/dirb-output-"$HOST"-"$PORT"-"$PROTO"-iis-s.txt;
elif [ "$SRV" == "apache" ];then
		dirb $PROTO://$HOST:$PORT "$APACHEWLD" -o ~/$CLIENT/dirb-output-"$HOST"-"$PORT"-"$PROTO"-apache-d.txt;
		dirb $PROTO://$HOST:$PORT "$APACHEWLS" -o ~/$CLIENT/dirb-output-"$HOST"-"$PORT"-"$PROTO"-apache-s.txt;
else
	printf "\nDammit Bobby.\n\n"
fi
fi
