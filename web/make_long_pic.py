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
cmd = "makeLongPic"
username = "pictrail"
selected_pic = [{'no': 0, 'picIndex': 304},{'no': 1, 'picIndex': 305}, ]

register_openers()

upload_file = ""
try:
	opts,arg = getopt.gnu_getopt(sys.argv, "u:", ["help", "grammar="])
except getopt.GetoptError as err:
	print str(err)
	sys.exit(2)
for o, a in opts:
	if o == '-u':
		username = a

json_data = {
	'cmd': cmd,
	'username': username,
	'picCount': len(selected_pic),
	'picArray': selected_pic,
}

#if len(upload_file) != 0:
#	datagen, headers = multipart_encode({"file": open(upload_file, "rb"), "json": json.dumps(json_data)})

#	request = urllib2.Request(url, datagen, headers)

#	print urllib2.urlopen(request).read()
headers = {'content-type': 'application/json'}
r = requests.post(url, data=json.dumps(json_data), headers=headers)

print r.text
