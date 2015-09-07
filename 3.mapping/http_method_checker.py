#!/usr/bin/python
# http_method_checker.py - HTTP Method request tool
# v0.02 2015/09/07
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
usage = '\r\nSyntax: %s <ip|hostname> <port> <-v|optional>\r\n' % (sys.argv[0])
if len(sys.argv) < 3:
	print usage
	sys.exit(1)

import socket
host = str(sys.argv[1])
port = int(sys.argv[2])
methods = 'OPTIONS GET HEAD POST PUT DELETE TRACE CONNECT PROPFIND PROPPATCH MKCOL COPY MOVE LOCK UNLOCK VERSION-CONTROL REPORT CHECKOUT CHECKIN UNCHECKOUT MKWORKSPACE UPDATE LABEL MERGE BASELINE-CONTROL MKACTIVITY ORDERPATCH ACL PATCH SEARCH'
list = methods.split(' ')

for i in xrange(0, len(list)):
	method = list[i]
	s = socket.socket()
	s.connect((host, port))
	s.send('%s / HTTP/1.1\r\nHost: %s\r\n\r\n' % (method, host))
        #s.send(method + ' / HTTP/1.1\r\nHost: ' + host + '\r\n\r\n')
	data = s.recv(1024)
	s.close()
	if len(sys.argv) == 4:
		if str(sys.argv[3]) == '-v':
			print '\r\n[+]\r\n[+] %s got this response\r\n[+]' % (method)
			print data.split('\r\n\r\n')[0]
		else:
			print '\r\n[!] Dammit Bobby.\r\n'
			sys.exit(1)
	elif len(sys.argv) == 3:
		resp = data.split('\r\n')[0]
		print '[+] %s: \t %s' % (method, resp)
	else:
		print '\r\n[!] Dammit Bobby.\r\n'
		sys.exit(1)
