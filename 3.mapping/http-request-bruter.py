import sys, socket
if len(sys.argv) < 3:
    sys.exit('\nUsage: %s <host|10.1.1.1> <port|443> <file|/tmp/burp.req> \n' % sys.argv[0])

host = str(sys.argv[1])
port = int(sys.argv[2])
file = str(sys.argv[3])

s = socket.socket()
s.connect((host, port))

payload = open(file,'rb')
print 'Sending...'
s.send(payload.read(2048))
payload.close()
print "Done Sending"
print s.recv(1024)
s.close
