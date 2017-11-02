import sys, socket

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
