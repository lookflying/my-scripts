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
cmd = "userLogin"
username = "pictrail"
password = "pictrailAdmin"
#location = "Shanghai"
#longitude = "121.496595"
#latitude = "31.241845"
#scale = 100
#start_idx = 3
#refresh_count = 5
#detail = "I Love Shanghai"
#pic_index = 3
register_openers()

#upload_file = ""
try:
	opts,arg = getopt.gnu_getopt(sys.argv, "u:p:")
except getopt.GetoptError as err:
	print str(err)
	sys.exit(2)
for o, a in opts:
	if o == '-u':
		username = a
	elif o == '-p':
		password = a

json_data = {
	'cmd': cmd,
	'username': username,
	'password': hashlib.md5(password).hexdigest(),
}

#if len(upload_file) != 0:
#	datagen, headers = multipart_encode({"file": open(upload_file, "rb"), "json": json.dumps(json_data)})

#	request = urllib2.Request(url, datagen, headers)

#	print urllib2.urlopen(request).read()
headers = {'content-type': 'application/json'}
r = requests.post(url, data=json.dumps(json_data), headers=headers)

print r.text
