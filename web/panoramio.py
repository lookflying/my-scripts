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


url="http://www.panoramio.com/map/get_panoramas.php"

from_idx = 0
to_idx = 20

longitude = 121.502488
latitude = 31.246075

register_openers()

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
						request = urllib2.Request(upload_url, datagen, headers)
						print urllib2.urlopen(request).read()


try:
	opts,args = getopt.gnu_getopt(sys.argv, "h", ["longitude=", "latitude=", "from=", "to=", "coordinate="])
except getopt.GetoptError as err:
	print str(err)
	sys.exit(2)
for opt, arg in opts:
	if opt == "--longitude":
		longitude = arg
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

minx = Decimal(longitude) - Decimal(0.001)
miny = Decimal(latitude) - Decimal(0.001)
maxx = Decimal(longitude) + Decimal(0.001)
maxy = Decimal(latitude) + Decimal(0.001)


params={
	'set': 'public',
	'from': from_idx,
	'to'	:	to_idx,
	'minx': minx,
	'miny': miny,
	'maxx': maxx,
	'maxy': maxy,
	'size': 'original',
	'mapfilter': 'true'

}

r = requests.get(url, params=params)
#print r.url
#print r.text 

data = json.loads(r.text)
if data.has_key('photos'):
		actual_count = len(data['photos'])	
		for photo in data['photos']:
			print photo['photo_title']
			pic_url = photo['photo_file_url']
			os.system('wget -N ' + pic_url	)

json_file_name = str(longitude) + "_" + str(latitude) + "_" + str(from_idx) + "_" + str(to_idx) + "_" + str(actual_count) + ".json"
with open(json_file_name, 'wb+') as outfile:
	outfile.write(r.text)

upload_pic_in_json(json_file_name)
