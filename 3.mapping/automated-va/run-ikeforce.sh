#!/bin/bash
# git clone https://github.com/SpiderLabs/ikeforce.git
if [ -z $5 ];then printf "\nSyntax: ./$0 <client> <ip|1.1.1.1> <Enc|5> <Hash|1> <Auth|1> <DH|2>\n"
echo "
Enc Type (1)	Hash Type (2)	Auth Type (3)		DH Group (4)
1 = DES		1 = HMAC-MD5	1 = PSK			1 = 768-bit MODP group
2 = IDEA	2 = HMAC-SHA	2 = DSS-Sig		2 = 1024-bit MODP group
3 = Blowfish	3 = TIGER	3 = RSA-Sig		3 = EC2N group on GP[2^155]
4 = RC5-R16-B64	4 = SHA2-256	4 = RSA-Enc		4 = EC2N group on GP[2^185]
5 = 3DES	5 = SHA2-384	5 = Revised RSA-Sig	5 = 1536-bit MODP group
6 = CAST	6 = SHA2-512	64221 = Hybrid Mode
7 = AES				65001 = XAUTHInitPreShared
"
	else
CLIENT=$1; cd ~/ikeforce/
#sudo python ikeforce.py $2 -e -w wordlists/groupnames.dic -t $3 $4 $5 $6 | tee ~/$CLIENT/ikeforce-output-$2.txt
sudo python ikeforce.py $2 -e -w wordlists/groupnames.dic -t $3 $4 $5 $6
cd ..
fi
