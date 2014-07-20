#!/usr/bin/python
from poster.encode import multipart_encode
from poster.streaminghttp import register_openers
import urllib2
import json
import sys
import getopt
import requests
import hashlib
url = "http://pictrail.tk/interface/"
#url = "http://203.195.155.219/interface/"
cmd = "raise"
username = "comment"
#password = "pictrailAdmin"
#location = "Shanghai"
#longitude = "121.496595"
#latitude = "31.241845"
#scale = 100
#start_idx = 3
#refresh_count = 5
#detail = "I Love Shanghai"
pic_index = 2 
#action = 1
comment = "good picture"
register_openers()
#upload_file = ""
try:
	opts,arg = getopt.gnu_getopt(sys.argv, "u:i:c:")
except getopt.GetoptError as err:
	print str(err)
	sys.exit(2)
for o, a in opts:
	if o == '-u':
		username = a
	elif o == '-i':
		pic_index = a	
	elif o == '-c':
		comment = a

json_data = {
	'cmd': cmd,
	'username': username,
	'picIndex': pic_index,
	'comment': comment,
}

#if len(upload_file) != 0:
#	datagen, headers = multipart_encode({"file": open(upload_file, "rb"), "json": json.dumps(json_data)})

#	request = urllib2.Request(url, datagen, headers)

#	print urllib2.urlopen(request).read()
headers = {'content-type': 'application/json'}
r = requests.post(url, data=json.dumps(json_data), headers=headers)

print r.text
