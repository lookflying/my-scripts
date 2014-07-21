#!/usr/bin/python
import sys
import getopt

try:
	opts,args = getopt.gnu_getopt(sys.argv, "h", ["longitude=", "latitude=", "from=", "to=",])
except getopt.GetoptError as err:
	print str(err)
for opt, arg in opts:
	if opt == "--longitude":
		longitude = arg
	elif opt == "--latitude":
		latitude = arg
	elif opt == "--from":
		from_idx = arg
	elif opt == "--to":
		to_idx = arg

print str(to_idx)
