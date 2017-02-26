#!/bin/bash
# http://sourceforge.net/projects/dirb/files/
if [ -z $1 ]; then printf "\nSytnax: $0 <client>\n\n"
	else
CLIENT=$1;

APACHEWL=`echo '/usr/share/dirb/wordlists/vulns/apache.txt
/usr/share/dirb/wordlists/vulns/axis.txt
/usr/share/dirb/wordlists/catala.txt
/usr/share/dirb/wordlists/vulns/cgis.txt
/usr/share/dirb/wordlists/vulns/tomcat.txt
/usr/share/seclists/Discovery/Apache.fuzz.txt
/usr/share/seclists/Discovery/ApacheTomcat.fuzz.txt
/usr/share/seclists/Discovery/PHP.fuzz.txt
/usr/share/seclists/Discovery/PHP_CommonBackdoors.fuzz.txt'|tr "\n" ","|sed "s/,$//g;"`;

IISWL=`echo '/usr/share/dirb/wordlists/vulns/frontpage.txt
/usr/share/dirb/wordlists/vulns/iis.txt
/usr/share/dirb/wordlists/vulns/sharepoint.txt
/usr/share/seclists/Discovery/IIS.fuzz.txt
/usr/share/seclists/Discovery/CGI_HTTP_POST_Windows.fuzz.txt
/usr/share/seclists/Discovery/Sharepoint.fuzz.txt
/usr/share/seclists/Discovery/Frontpage.fuzz.txt
/usr/share/seclists/Discovery/CGI_Microsoft.fuzz.txt'|tr "\n" ","|sed "s/,$//g;"`;

for APACHE in $(grep -i apache ~/$CLIENT/whatweb-output-*.txt|egrep -o 'http[s]?:\/\/[^/]+:[0-9]{1,5}'|sort -u); do
	dirb "$APACHE" $APACHEWL -o "~/$CLIENT/dirb-output-$(echo $APACHE|tr -d '/'|tr ':' '_')-apache.txt";
done
for IIS in $(egrep -B1 'HTTPServer.*Microsoft\-[HI]' whatweb-output-*|egrep -o 'http[s]?:\/\/[^/]+:[0-9]{1,5}'|sort -u|sed 's/[0-9]\/.*$/&/g;'); do
	dirb "$IIS" $IISWL -o "~/$CLIENT/dirb-output-$(echo $IIS|tr -d '/'|tr ':' '_')-iis.txt";
done
fi
