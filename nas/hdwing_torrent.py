#!/usr/bin/python
import requests, shutil
import urllib
import os
import sys
import time
torrents_dir = "hdwing"
header_info = {
                "Cookie":"uid=188165; pass=7f41288740295acab53d1fc6584281e2; __utmt=1; _gat=1; __utma=165514086.1919767052.1409988546.1412687565.1412690038.11; __utmb=165514086.4.10.1412690038; __utmc=165514086; __utmz=165514086.1409988546.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.2.1919767052.1409988546",
}
if not os.path.exists(torrents_dir):
	os.makedirs(torrents_dir);

def fetch(tid, retry):
	if retry > 10:
		return
	r = requests.get("http://hdwing.com/downloads.php?id=" + str(tid), headers=header_info, stream=True)
	if r.status_code == 200:
		name = urllib.unquote(r.headers['Content-Disposition'].split(";")[1].strip().replace('filename=', ''))
		print name
		with open(torrents_dir + "/" + name, 'wb') as f:
			r.raw.decode_content = True
			shutil.copyfileobj(r.raw, f)


line = sys.stdin.readline()
while line:
	print line
	fetch(line, 0)
	line = sys.stdin.readline()
