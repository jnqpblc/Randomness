#!/usr/bin/python
# single_port_finger.py - The name says it all.
# v0.02 2015/04/15
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

import sys

if len(sys.argv) < 3:
    sys.exit('\nUsage: %s 192.168.1.10 80|443|21|22|23|etc\n' % sys.argv[0])

import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *

target = sys.argv[1]
dstport = int(sys.argv[2])

scan=IP(dst=target)/TCP(sport=RandNum(1024,65535),dport=[dstport],flags="S")
ans,unans=(sr(scan,inter=0.0000001,timeout=1,verbose=0,filter="src " + target))
for snd,rcv in ans:
	print "IP/TCP ttl:" + str(rcv.ttl), str(rcv.src) + ":" + str(rcv.sport) + " > " + str(rcv.dst) + ":" + str(rcv.dport) + " " + rcv.sprintf('%TCP.flags%')
	
