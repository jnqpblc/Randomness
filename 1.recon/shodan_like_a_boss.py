#!/usr/bin/env python
# shodan_like_a_boss.py - Commandline ShodanHQ search tool
# v0.02 2015/01/22
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


SHODAN_API_KEY = "{INSERT API KEY HERE}"


import sys
from optparse import OptionParser

blah = "[ -s apache | -i 8.8.8.8 | -n 8.8.8.0/24 ]\n"
usageString = "%prog " + blah
parser = OptionParser(usage=usageString,description='shodan_like_a_boss.py - Commandline ShodanHQ search tool');
parser.add_option('-s', '--search', dest='search',
		help='Queries Shodan for a given string.');
parser.add_option('-i', '--ip', dest='host',
		help='Queries Shodan for a given ip address.');
parser.add_option('-n', '--network', dest='network',
		help='Queries Shodan for a given network in CIDR notation.');
		
(opts,args) = parser.parse_args()

usage = '\nUsage: %s ' % sys.argv[0] + blah

if (opts.search != None) or (opts.host != None) or (opts.network != None):
	pass
else:
	print usage
	print "Error: argument required\n"
	exit()

import shodan
api = shodan.Shodan(SHODAN_API_KEY)

def searchString(string):
   try:
	search = api.search(string)
	print ''
	print 'Results found: %s' % search['total']
	for result in search['matches']:
		print 'IP: %s' % result['ip_str']
		print result['data']
		print ''
   except shodan.APIError, e:
	print 'Error: %s' % e

def searchHost(host):
   try:
	host = api.host(host)
	print ''
	print 'IP: %s' % (host['ip_str'])
	print 'Organization: %s' % (host.get('org', 'n/a'))
	print 'Operating System: %s' % (host.get('os', 'n/a'))
	print ''
	for item in host['data']:
	        print 'Port: %s' % (item['port'])
		print 'Banner: %s '% (item['data'])
	print ''

   except shodan.APIError, e:
	print 'Error: %s' % e

def searchNetwork(network):
   try:
	host = api.network(network)
	print ''
	print 'IP: %s' % (network['ip_str'])
	print 'Organization: %s' % (network.get('org', 'n/a'))
	print 'Operating System: %s' % (network.get('os', 'n/a'))
	print ''
	for item in network['data']:
	        print 'Port: %s' % (item['port'])
		print 'Banner: %s '% (item['data'])
	print ''

   except shodan.APIError, e:
	print 'Error: %s' % e

if __name__ == '__main__':

   if opts.search != None:
	string = opts.search
	print opts.search
	searchString(string)

   elif opts.host != None:
	host = opts.host
	print opts.host
	searchHost(host)

   elif opts.network != None:
	print "This function is currently broken"
	#network = opts.network
	#print opts.network
	#searchNetwork(network)

   else:
	exit(usage)
