#!/usr/bin/python
import requests
import sys
import getopt
import json

url="http://www.panoramio.com/map/get_panoramas.php"

from_idx = 0
to_idx = 3

longitude = 121.502488
latitude = 31.246075

try:
	opts,args = getopt.gnu_getopt(sys.argv, "h", ["longitude=", "latitude=", "from=", "to=",])
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
		print str(to_idx)

minx = longitude - 0.001
miny = latitude - 0.001
maxx = longitude + 0.001
maxy = latitude + 0.001


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
		for photo in data['photos']:
			print photo['photo_title']
			print photo['photo_file_url']
			print "(" + str(photo['longitude']) + "," + str(photo['latitude']) + ")"
			print photo['upload_date']
			
