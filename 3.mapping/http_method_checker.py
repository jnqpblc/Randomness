#!/usr/bin/python
import sys
usage = '\r\nSyntax: %s <ip|hostname> <port>\r\n' % (sys.argv[0])
if len(sys.argv) < 2:
	print usage
	sys.exit(1)

import socket
host = str(sys.argv[1])
port = int(sys.argv[2])
methods = 'OPTIONS GET HEAD POST PUT DELETE TRACE CONNECT'
list = methods.split(' ')

for i in xrange(0, len(list)):
	method = list[i]
	s = socket.socket()
	s.connect((host, port))
	# s.send('%s / HTTP/1.1\r\nHost: %s\r\n\r\n') % (method, host)
	s.send(method + ' / HTTP/1.1\r\nHost: ' + host + '\r\n\r\n')
	data = s.recv(1024)
	s.close()
	print '\r\n[+] %s got this response' % (method)
	print data.split('\r\n\r\n')[0]
