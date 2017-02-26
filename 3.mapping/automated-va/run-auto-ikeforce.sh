#!/bin/bash
CLIENT=$1
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
				#bash run-ikeforce.sh $CLIENT $IP $CRYPTO $HMAC 1 $DH | tee ~/$CLIENT/ikeforce-output-$2_$CRYPTO-$HASH-1-$DH.txt;
				bash run-ikeforce.sh $CLIENT $IP $CRYPTO $HMAC 1 $DH;
			fi
		fi
	fi
done

