#!/usr/bin/python
# dns_server_discover.py - Scapy dns mass ptr query tool
# v0.01 2015/09/10
#
# Copyright (C); 2015 jnqpblc - jnqpblc at gmail
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option); any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# sudo pip install pcapy PyDNET graphillion networkx python-yaml;
#
import sys
if len(sys.argv) < 2:
    sys.exit('\nUsage: %s <192.168.1.53|192.168.1.50-60|192.168.1.0/24>\n' % sys.argv[0])

import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *

subnet = sys.argv[1]

ans, unans = sr(IP(dst=subnet)/UDP(dport=53)/DNS(rd=1,qd=DNSQR(qname="1.0.0.127.in-addr.arpa.")),verbose=0,timeout=3)
for resp in ans[0:]:
	try:
		if resp[1][UDP]:
			print "[+] Response: TTL = %s, SRC = %s -> %s" % (resp[1][IP].ttl, resp[1][IP].src, resp[1][DNSRR].sprintf("%rdata%").split("\\x00")[0].strip("'"))
		else:
			print "if failed."
	except:
		#print "[!] No Response from %s" % (resp[0][IP].dst)
		None
