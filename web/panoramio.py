#!/usr/bin/python
import requests
import sys
import getopt
import json
from decimal import Decimal
import os
url="http://www.panoramio.com/map/get_panoramas.php"

from_idx = 0
to_idx = 20

longitude = 121.502488
latitude = 31.246075

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
			
with open(str(longitude) + "_" + str(latitude) + "_" + str(from_idx) + "_" + str(to_idx) + "_" + str(actual_count) + ".json", 'wb+') as outfile:
	outfile.write(r.text)
