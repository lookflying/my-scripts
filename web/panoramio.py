#!/usr/bin/python
import requests
url="http://www.panoramio.com/map/get_panoramas.php"
params={
	'set': 'public',
	'from': '0',
	'to': '20',
	'minx': '-180',
	'miny': '-90',
	'maxx': '180',
	'maxy': '90',
	'size': 'medium',
	'mapfilter': 'true'

}

r = requests.get(url, params=params)
print r.url
print r.text 
