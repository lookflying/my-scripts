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

def upload_pic_in_json(json_file):
	with open(json_file, "rb+") as in_file:
		json_data = json.loads(in_file.read())
		if json_data.has_key('photos'):
				for photo in json_data['photos']:
#					print photo['photo_title']
					upload_json = {
						'cmd': 'publishPic',
						'username': 'pictrail',
						'longitude': photo['longitude'],
						'latitude': photo['latitude'],
						'location': photo['photo_title'],
						'detail': photo['photo_title'],
						'time': photo['upload_date'],
					}			
					filename = os.path.basename(photo['photo_file_url'])
					if os.path.isfile(filename):
						print "upload " + filename
						datagen, headers = multipart_encode({"uploadFile": open(filename, "rb"), "JSON": json.dumps(upload_json)})
						request = urllib2.Request(url, datagen, headers)
						print urllib2.urlopen(request).read()



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
	if os.path.isdir(json_dir):
		for f in os.listdir(json_dir):
			if f.endswith(".json"):
				upload_pic_in_json(f)
elif json_file:
	 upload_pic_in_json(json_file)
#	with open(json_file, "rb+") as in_file:
#		json_data = json.loads(in_file.read())
#		if json_data.has_key('photos'):
#				for photo in json_data['photos']:
##					print photo['photo_title']
#					upload_json = {
#						'cmd': 'publishPic',
#						'username': 'pictrail',
#						'longitude': photo['longitude'],
#						'latitude': photo['latitude'],
#						'location': photo['photo_title'],
#						'detail': photo['photo_title'],
#						'time': photo['upload_date'],
#					}			
#					filename = os.path.basename(photo['photo_file_url'])
#					if os.path.isfile(filename):
#						print "upload " + filename
#						datagen, headers = multipart_encode({"uploadFile": open(filename, "rb"), "JSON": json.dumps(upload_json)})
#						request = urllib2.Request(url, datagen, headers)
#						print urllib2.urlopen(request).read()
