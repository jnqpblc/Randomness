#!/usr/bin/python
# arping.py - Scapy arp ping tool
# v0.02 2014/11/21
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
    sys.exit('\nUsage: %s 192.168.1.0/24 eth0\n' % sys.argv[0])

import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *

subnet = sys.argv[1]
inet = sys.argv[2]

arping(subnet,iface=inet,timeout=4,cache=0,verbose=None)
