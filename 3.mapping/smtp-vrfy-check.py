#!/usr/bin/env python
# simple smtp VRFY checker.. that works! 
# created by brad-anton. Modified by jnqpblc.
# https://raw.githubusercontent.com/OpenSecurityResearch/pentest-scripts/master/smtp-vrfy-check.py

import socket
import getopt
import sys
import re

def usage():
	help = "Options:\n"
	help += "\t-h <host>\t host\n"
	help += "\t-p <port>\t port (Default: 25)\n"
	help += "\t-d <domain>\t domain\n"
	help += "\t-w <filename>\t wordlist\n"
	help += "\t-v \t\t verbose\n"
	return help

def main():
	print ""
	print "SMTP VRFY Checker"
	print "Created by brad-anton. Modified by jnqpblc."
	print "-------------------------------------------"
	print ""
	
        try:
                opts, args = getopt.getopt(sys.argv[1:], "h:p:d:w:v",[])
        except getopt.GetoptError:
                print usage()
                return

        port = 25 
        verbose = host = domain = wordlist = 0

        for o, a in opts:
                if o == "-h":
                        host = a
                if o == "-p":
                        port = int(a)
                if o == "-d":
                        domain = a
                if o == "-w":
                        wordlist = a
		if o == "-v":
			verbose = 1
        if (host == 0) or (wordlist == 0):
                print usage()
                return

	print "[+] Establishing connection to",host,":",port

	try:
		s = socket.socket()
		s.settimeout(4)
		recv_data = 0
		s.connect((host,port))
		banner = s.recv(512)
	except socket.error as e:
        	print "[!] Connection error -> ",e,"\n"
		sys.exit(1)

	if verbose == 1:
		print "[v] Banner:"
		print banner
	
	file = open(wordlist,'r')
	count = 1
	for line in file:

		if count % 10 == 0:
			if verbose == 1:
				print "[v] Attempted ten usernames, reconnecting"
			s.shutdown(2) 
			s.close

			try:
                		s = socket.socket()
                		s.settimeout(4)
                		recv_data = 0
                		s.connect((host,port))
		        except socket.error as e:
				print "[!] Connection error -> ",e,"\n"
                		sys.exit(1)

			banner = s.recv(512)
			if verbose == 1:
				print "[v] Banner:"
				print banner

		user = line.rstrip('\n')

		msg = "VRFY "
		if domain is not 0:
			msg += user + '@' + domain
		else:
			msg += user
		msg += "\n"
		if verbose == 1:
			print "[v] Sending:",msg.rstrip('\n')

		error = s.sendall(msg)
		
		if error:
			print "\n[!] Error with user",user,":", error
		else:
			try:
				recv_data = s.recv(512)
			except socket.timeout:
				print "[-] Timeout on user",user
			except socket.error as e:
				print "[!] Connection error -> ",e,"\n"

		if recv_data:
			#print recv_data
			if re.match("250",recv_data):
				print "[+] Found User:",user
			if verbose == 1:
				print "[+] User:",user,
				if re.match("550",recv_data):
					print " -> Not Found!"
				elif re.match("554",recv_data):
					print " -> Access Denied!"
				elif re.match("450",recv_data):
					print " -> Recipient Rejected!"
				elif re.match("252",recv_data):
					# http://cr.yp.to/smtp/vrfy.html
					print " -> Possibly Found User! ...but the server doesn't want to tell you."
				else:
					print " -> Unknown Error!"
				print recv_data	
		else:
			print "[-] No recv_data!\n"
		count+=1

	try:
		file.close()
		s.shutdown(2)
		s.close()
	except socket.error as e:
		print "[!] Connection error -> ",e,"\n"
		sys.exit(1)

main()
