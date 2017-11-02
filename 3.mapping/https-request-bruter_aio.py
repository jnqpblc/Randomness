import sys, socket, ssl, re
if len(sys.argv) < 3:
    sys.exit('\nUsage: %s <host|10.1.1.1> <port|443> <file|/tmp/burp.req> \n' % sys.argv[0])

# SET VARIABLES
HOST, PORT = str(sys.argv[1]), int(sys.argv[2])
FILE = str(sys.argv[3])
REQ_FILE = str(sys.argv[3])
USR_FILE = str(sys.argv[4])
PWD_FILE = str(sys.argv[5])

payload = open(REQ_FILE,'rb')
usernames = open(USR_FILE,'rb')
passwords = open(PWD_FILE,'rb')
packet, reply = payload.read(2048), ""

# REPLACE USER AND PASS
packet = packet.replace('^USER^', 'asdf')
packet = packet.replace('^PASS^', 'fdsa')

# CREATE SOCKET
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.settimeout(10)

# WRAP SOCKET
wrappedSocket = ssl.wrap_socket(sock, ssl_version=ssl.PROTOCOL_TLSv1)

# CONNECT AND PRINT REPLY
wrappedSocket.connect((HOST, PORT))
wrappedSocket.send(packet)
#print wrappedSocket.recv(64).split(" ",2)[1]
response = wrappedSocket.recv(64).split(" ",2)[1]

if int(response) == 401:
   print "Authentication failed."
elif int(response) == 200:
   print "Authentication succeeded."
elif int(response) == 302:
   print "We got redirected."
else:
   print "Dammit Bobby."
   print response

# CLOSE REQUEST FILE
payload.close()

# CLOSE SOCKET CONNECTION
wrappedSocket.close()
