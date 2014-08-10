#!/usr/bin/python
from poster.encode import multipart_encode
from poster.streaminghttp import register_openers
import urllib2
import json
import sys
import getopt
import requests

url = "http://pictrail.tk/interface/"
#url = "http://203.195.155.219/interface/"
cmd = "refreshPic"
#username = "pictrail"
#location = "Shanghai"
longitude = "121.403997"
latitude = "31.174043"
scale = 100
start_idx = 3
refresh_count = 5
#detail = "I Love Shanghai"

register_openers()

upload_file = ""
try:
	opts,arg = getopt.gnu_getopt(sys.argv, "s:i:c:", ["help", "grammar="])
except getopt.GetoptError as err:
	print str(err)
	sys.exit(2)
for o, a in opts:
	if o == '-s':
		scale = a
	elif o == '-i':
		start_idx = a
	elif o == '-c':
		refresh_count = a

json_data = {
	'cmd': cmd,
	'longitude': longitude,
	'latitude': latitude,
	'scale': scale,
	'startIndex': start_idx,
	'refreshCount': refresh_count,
}

#if len(upload_file) != 0:
#	datagen, headers = multipart_encode({"file": open(upload_file, "rb"), "json": json.dumps(json_data)})

#	request = urllib2.Request(url, datagen, headers)

#	print urllib2.urlopen(request).read()
headers = {'content-type': 'application/json'}
r = requests.post(url, data=json.dumps(json_data), headers=headers)

print r.text
