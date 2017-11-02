import sys, socket, ssl, re, time
if len(sys.argv) < 3:
    sys.exit('\nUsage: %s <host|10.1.1.1> <port|443> <file|/tmp/burp.req> <user|admin> <password|admin>\n' % sys.argv[0])

# SET VARIABLES
HOST, PORT = str(sys.argv[1]), int(sys.argv[2])
FILE = str(sys.argv[3])
USER = str(sys.argv[4])
PASS = str(sys.argv[5])

payload = open(FILE,'rb')
packet, reply = payload.read(2048), ""

# REPLACe USER AND PASS
packet = packet.replace('^USER^', USER)
packet = packet.replace('^PASS^', PASS)

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

timestamp = time.strftime("%Y-%m-%d %H:%M %p %Z")

if int(response) == 401:
   print "%s - Authentication failed." % (timestamp)
elif int(response) == 200:
   print "%s - Authentication succeeded with %s:%s\n" % (timestamp, USER, PASS)
elif int(response) == 302:
   print "%s - We got redirected." % (timestamp)
else:
   print "%s - Dammit Bobby. We got a %s" % (timestamp, response)

# CLOSE REQUEST FILE
payload.close()

# CLOSE SOCKET CONNECTION
wrappedSocket.close()
