#!/usr/bin/python
import requests
import sys
import getopt
import json
from decimal import Decimal
import os
json_file = False
try:
	opts,args = getopt.gnu_getopt(sys.argv, "h", ["json=", "json-dir="])
except getopt.GetoptError as err:
	print str(err)
	sys.exit(2)
for opt, arg in opts:
	if opt == "--json":
		json_file = arg
	elif opt == "--latitude":
		latitude = arg
	elif opt == "--from":
		from_idx = arg
	elif opt == "--to":
		to_idx = arg
	elif opt == "--coordinate":
		cdt_str = arg.split(",")
		longitude = cdt_str[0]
		latitude = cdt_str[1]

if json_file:
	with open(json_file, "rb+") as in_file:
		json_data = json.loads(in_file.read())
		if json_data.has_key('photos'):
				for photo in json_data['photos']:
					print photo['photo_title']
					
