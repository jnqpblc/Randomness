#!/usr/bin/python

import sys
if len(sys.argv) < 2:
    sys.exit('\nUsage: %s <file|empire.txt>\n' % sys.argv[0])

f = open(sys.argv[1],"r")
print base64.b64encode("".join([char + "\x00" for char in unicode(f.read())]))

