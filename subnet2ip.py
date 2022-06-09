#!/usr/bin/python
# subnet2ip.py - Converts CIDR to a list of IP Address to used in a for loop
# v0.01 2015/02/21
#
# Copyright (C); 2014 jnqpblc - jnqpblc at gmail
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
if len(sys.argv) < 2:
    sys.exit('\nUsage: %s 192.168.1.0/24\n' % sys.argv[0])

import socket, random
from netaddr import *

subnet = sys.argv[1]
for ip in IPNetwork(subnet): print('%s' % ip)
