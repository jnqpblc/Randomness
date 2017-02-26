#!/bin/bash
# svn co https://svn.nmap.org/nmap/
if [ -z $2 ]; then printf "\nSytnax: $0 <ip|10.10.10.10>\n\n"
	else
cd /root/nmap/
./nmap -Pn -sU -p 161 --script +snmp-brute $1
./nmap -Pn -sU -p 161 --script +snmp-brute --script-args snmp-brute.communitiesdb=/root/defaultpassword.com-passwords.txt $1
./nmap -Pn -sU -p 161 --script +snmp-brute --script-args snmp-brute.communitiesdb=/root/500-worst-passwords.txt $1
./nmap -Pn -sU -p 161 --script +snmp-brute --script-args snmp-brute.communitiesdb=/opt/metasploit/apps/pro/data/wordlists/snmp_default_pass.txt $1
./nmap -Pn -sU -p 161 --script +snmp-brute --script-args snmp-brute.communitiesdb=/root/fuzzdb/wordlists-misc/wordlist-common-snmp-community-strings.txt $1
./nmap -Pn -sU -p 161 --script +snmp-brute --script-args snmp-brute.communitiesdb=/root/nmap/nselib/data/snmpcommunities.lst $1
./nmap -Pn -sU -p 161 --script +snmp-brute --script-args snmp-brute.communitiesdb=/usr/share/wordlists/metasploit-pro/telnet_cisco_default_pass.txt $1
./nmap -Pn -sU -p 161 --script +snmp-brute --script-args snmp-brute.communitiesdb=/usr/share/wordlists/metasploit-pro/telnet_cisco_default_users.txt $1
./nmap -Pn -sU -p 161 --script +snmp-brute --script-args snmp-brute.communitiesdb=/usr/share/wordlists/nmap.lst $1
fi
