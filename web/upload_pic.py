#!/usr/bin/python
from poster.encode import multipart_encode
from poster.streaminghttp import register_openers
import urllib2
import json
import sys
import getopt

url = "http://pictrail.tk/interface/"
#url = "http://203.195.155.219/interface/"
cmd = "publishPic"
username = "pictrail"
location = "Shanghai"
longitude = "121.496595"
latitude = "31.241845"
detail = "I Love Shanghai"

register_openers()

upload_file = ""
try:
	opts,arg = getopt.gnu_getopt(sys.argv, "f:", ["help", "grammar="])
except getopt.GetoptError as err:
	print str(err)
	sys.exit(2)
for o, a in opts:
	if o == "-f":
		upload_file = a
json_data = {
	'cmd': cmd,
	'username': username,
	'longitude': longitude,
	'latitude': latitude,
	'location': location,
	'detail': detail,
}

if len(upload_file) != 0:
	datagen, headers = multipart_encode({"file": open(upload_file, "rb"), "json": json.dumps(json_data)})

	request = urllib2.Request(url, datagen, headers)

	print urllib2.urlopen(request).read()

