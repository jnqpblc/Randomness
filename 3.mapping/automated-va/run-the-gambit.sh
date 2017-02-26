#!/bin/bash
clear;
printf 'Type client abbreviation, followed by [ENTER]: '; read CLIENT
printf 'Type target domain, followed by [ENTER]: '; read DOMAIN
mkdir ~/$CLIENT/;
echo '# Enter the target IPs or Subnets, one line at a time. Use CTRL+X to exit and save.' > ~/$CLIENT/targets
nano ~/$CLIENT/targets
sed -ie 's/^#.*//g;:a;N;$!ba;s/^\n//g;' ~/$CLIENT/targets

PROMPT="$(date +\"$USER@$(hostname):$PWD:%Y-%m-%d-%T~$\")"

echo "$PROMPT bash run-masscan.sh $CLIENT ~/$CLIENT/targets 4000 | tee ~/$CLIENT/all.masscan"
bash run-masscan.sh $CLIENT ~/$CLIENT/targets 4000 | tee ~/$CLIENT/all.masscan
sort -k6 ~/$CLIENT/masscan-output.txt
echo "$PROMPT bash masscan-stdout-to-nmap.sh ~/$CLIENT/masscan-output.txt $CLIENT | tee ~/$CLIENT/all.nmap.tcp"
bash masscan-stdout-to-nmap.sh ~/$CLIENT/masscan-output.txt $CLIENT | tee ~/$CLIENT/all.nmap.tcp
echo "$PROMPT bash masscan-stdout-to-nikto.sh ~/$CLIENT/masscan-output.txt $CLIENT | tee ~/$CLIENT/all.nikto"
bash masscan-stdout-to-nikto.sh ~/$CLIENT/masscan-output.txt $CLIENT | tee ~/$CLIENT/all.nikto
echo "$PROMPT bash masscan-stdout-to-sslyze.sh ~/$CLIENT/masscan-output.txt $CLIENT | tee ~/$CLIENT/all.sslyze"
bash masscan-stdout-to-sslyze.sh ~/$CLIENT/masscan-output.txt $CLIENT | tee ~/$CLIENT/all.sslyze
echo "$PROMPT bash nikto-txt-to-whatweb.sh  $CLIENT | tee ~/$CLIENT/all.whatweb"
bash nikto-txt-to-whatweb.sh  $CLIENT | tee ~/$CLIENT/all.whatweb
echo "$PROMPT bash nikto-txt-to-dirb.sh $CLIENT | tee ~/$CLIENT/all.dirb"
bash nikto-txt-to-dirb.sh $CLIENT | tee ~/$CLIENT/all.dirb
echo "$PROMPT bash whatweb-txt-to-dirb.sh $CLIENT | tee ~/$CLIENT/all.dirb.ww"
bash whatweb-txt-to-dirb.sh $CLIENT | tee ~/$CLIENT/all.dirb.ww
echo "$PROMPT bash whatweb-txt-to-dirb.sh $CLIENT | tee ~/$CLIENT/all.dirb.ww"
bash whatweb-txt-to-dirb.sh $CLIENT | tee ~/$CLIENT/all.dirb.ww
#echo "$PROMPT bash nikto-txt-to-wpscan.sh $CLIENT | tee ~/$CLIENT/all.wpscan"
#bash nikto-txt-to-wpscan.sh $CLIENT | tee ~/$CLIENT/all.wpscan
echo "$PROMPT bash nikto-txt-to-sqlmap.sh $CLIENT | tee ~/$CLIENT/all.sqlmap"
bash nikto-txt-to-sqlmap.sh $CLIENT | tee ~/$CLIENT/all.sqlmap
echo "$PROMPT bash nikto-txt-to-w3af.sh $CLIENT $(OLDPWD)audit-high-risk.w3af | tee ~/$CLIENT/all.w3af"
bash nikto-txt-to-w3af.sh $CLIENT $(OLDPWD)audit-high-risk.w3af | tee ~/$CLIENT/all.w3af
echo "$PROMPT perl ../fierce.pl -dns $DOMAIN -wordlist ../fierce-master-wordlist.txt"
perl ../fierce.pl -dns $DOMAIN -wordlist ../fierce-master-wordlist.txt
echo "$PROMPT bash nmap-known-udp-ports.sh $CLIENT ~/$CLIENT/targets | tee ~/$CLIENT/all.nmap.udp"
bash nmap-known-udp-ports.sh $CLIENT ~/$CLIENT/targets  | tee ~/$CLIENT/all.nmap.udp

echo "$PROMPT sudo ike-scan -f ~/$CLIENT/targets  | tee ~/$CLIENT/ikescan-output-all.txt"
sudo ike-scan -f ~/$CLIENT/targets  | tee ~/$CLIENT/ikescan-output-all.txt

cd ~/ikeforce/
for ip in $(awk '{print $1}' ~/$CLIENT/ikescan-output-all.txt|egrep '^[0-9]{1,3}'); do
	echo "$PROMPT sudo python ikeforce.py $ip -a | tee ~/$CLIENT/ikeforce-output-$ip-useable-transforms.txt"
	sudo python ikeforce.py $ip -a | tee ~/$CLIENT/ikeforce-output-$ip-useable-transforms.txt;
done
cd -

### Use ikescan to get transforms
for IP in $(awk '{print $1}' ~/$CLIENT/ikescan-output-all.txt|egrep '^[0-9]{1,3}'); do
	echo "$PROMPT bash run-ikescan.sh $CLIENT $IP -a;"
	bash run-ikescan.sh $CLIENT $IP -a;
	echo "$PROMPT sudo python ~/iker.py $IP | tee ~/$CLIENT/iker-output-$IP.txt"
	sudo python ~/iker.py $IP | tee ~/$CLIENT/iker-output-$IP.txt
done

### Use ikeforce to perform groupname guessing.
IFS=$'\n';
for line in $(grep -H 'Auth=PSK' ~/$CLIENT/ikescan-output-*aggressive-mode.txt); do
        IP=$(echo $line|egrep -o '([0-9]{1,3}\.){3}([0-9]{1,3})');
        ENC=$(echo $line|egrep -o 'Enc=[^ ]+');
        HASH=$(echo $line|egrep -o 'Hash=[^ ]+');
        GROUP=$(echo $line|egrep -o 'Group=[0-9]');

if [ $ENC == 'Enc=3DES' ];then CRYPTO='5';
elif  [ $ENC == 'Enc=AES' ];then CRYPTO='7';
elif  [ $ENC == 'Enc=DES' ];then CRYPTO='1';
else
        printf '\nDammit Bobby. Wrong crypto.\n'
        exit 0
fi

if [ $HASH == 'Hash=MD5' ];then HMAC='1';
elif  [ $HASH == 'Hash=SHA1' ];then HMAC='2';
elif  [ $HASH == 'Hash=SHA2-256' ];then HMAC='4';
elif  [ $HASH == 'Hash=SHA2-384' ];then HMAC='5';
elif  [ $HASH == 'Hash=SHA2-512' ];then HMAC='6';
else
        printf '\nDammit Bobby. Wrong hmac.\n';
        exit 0;
fi

if [ $GROUP == 'Group=1' ];then DH='1';
elif  [ $GROUP == 'Group=2' ];then DH='2';
elif  [ $GROUP == 'Group=5' ];then DH='5';
else
        printf '\nDammit Bobby. Wrong group.\n';
        exit 0;
fi

if [ -z  $CRYPTO ];then
                printf '\nDammit Bobby. Empty crypto\n';
                exit 0;
        else
                if [ -z  $HASH ];then
                        printf '\nDammit Bobby. Empty hash\n';
                        exit 0;
                else
                        if [ -z  $DH ];then
                                printf '\nDammit Bobby. Empty dh\n';
                                exit 0
                        else
                                #echo "$PROMPT bash run-ikeforce.sh $CLIENT $IP $CRYPTO $HMAC 1 $DH | tee ~/$CLIENT/ikeforce-output-$2_$CRYPTO-$HASH-1-$DH.txt;"
                                #bash run-ikeforce.sh $CLIENT $IP $CRYPTO $HMAC 1 $DH | tee ~/$CLIENT/ikeforce-output-$2_$CRYPTO-$HASH-1-$DH.txt;
                                echo "$PROMPT bash run-ikeforce.sh $CLIENT $IP $CRYPTO $HMAC 1 $DH;"
                                bash run-ikeforce.sh $CLIENT $IP $CRYPTO $HMAC 1 $DH;
                        fi
                fi
        fi
done
