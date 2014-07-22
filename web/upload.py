#!/usr/bin/python
import requests
import sys
import getopt
import json
from decimal import Decimal
import os
from poster.encode import multipart_encode
from poster.streaminghttp import register_openers
import urllib2
json_file = False
json_dir = False
url = 'http://pictrail.tk/interface/manage/'

register_openers()

try:
	opts,args = getopt.gnu_getopt(sys.argv, "h", ["json=", "json-dir="])
except getopt.GetoptError as err:
	print str(err)
	sys.exit(2)
for opt, arg in opts:
	if opt == "--json":
		json_file = arg
	elif opt == "--json-dir":
		json_dir = arg

if json_dir:
	pass
elif json_file:
	with open(json_file, "rb+") as in_file:
		json_data = json.loads(in_file.read())
		if json_data.has_key('photos'):
				for photo in json_data['photos']:
					print photo['photo_title']
					upload_json = {
						'cmd': cmd,
						'username': 'pictrail',
						'longitude': photo['longitude'],
						'latitude': photo['latitude'],
						'location': photo['photo_title'],
						'detail': photo['photo_title'],
						'time': photo['upload_date'],
					}			
					datagen, headers = multipart_encode({"file": open(upload_file, "rb"), "json": json.dumps(json_data)})
				
					request = urllib2.Request(url, datagen, headers)
				
					print urllib2.urlopen(request).read()
