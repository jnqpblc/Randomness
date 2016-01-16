#!/bin/bash
if [ -z $1 ];then printf "\nSyntax: $0 <'query'|'example*'|'example*limited*'|'*example*'>\n\n"
	else
query=$1

for organization in $(curl "http://whois.arin.net/rest/orgs;name=$query" 2>/dev/null | egrep -o 'handle="[^"]*"' | awk -F'"' '{print $2}' | sort -u); do
	for netblock in $(curl "http://whois.arin.net/rest/org/$organization/nets" 2>/dev/null | egrep -o 'NET-[0-9]{1,3}-[0-9]{1,3}-[0-9]{1,3}-[0-9]{1,3}-[0-9]' | sort -u); do
		echo "### $organization - $netblock:"
		curl "http://whois.arin.net/rest/net/$netblock.txt" 2>/dev/null | egrep 'NetRange|CIDR|NetName|NetHandle|Customer|RegDate';
		echo ""
	done
done

for customer in $(curl "http://whois.arin.net/rest/customers;name=$query" 2>/dev/null | egrep -o 'C[0-9]{8}' | sort -u); do
	for netblock in $(curl "http://whois.arin.net/rest/customer/$customer/nets" 2>/dev/null | egrep -o 'NET-[0-9]{1,3}-[0-9]{1,3}-[0-9]{1,3}-[0-9]{1,3}-[0-9]' | sort -u); do
		echo "### $customer - $netblock:"
		curl "http://whois.arin.net/rest/net/$netblock.txt" 2>/dev/null | egrep 'NetRange|CIDR|NetName|NetHandle|Customer|RegDate';
		echo ""
	done
done
fi
