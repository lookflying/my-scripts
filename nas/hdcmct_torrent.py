#!/usr/bin/python
import requests, shutil
import urllib
import os
import sys
import time
torrents_dir = "hdcmct"
if not os.path.exists(torrents_dir):
	os.makedirs(torrents_dir);
cookies = dict(c_secure_uid="MzIyNzY%3D", c_secure_pass="fb86ea5c369db4ec1d7b793e5640adbe", c_secure_ssl="eWVhaA%3D%3D", c_secure_tracker_ssl="bm9wZQ%3D%3D", c_secure_login="bm9wZQ%3D%3D", CNZZDATA2347483="cnzz_eid%3D323403713-1410257280-%26ntime%3D1412683322", CNZZDATA3438961="cnzz_eid%3D1127473441-1410256947-%26ntime%3D1412683322", __utma="220415681.1265519012.1409983415.1412062860.1412683324.16", __utmb="220415681.10.10.1412683324", __utmc="220415681",)

def fetch(tid, retry):
	if retry > 10:
		return
	r = requests.get("http://hdcmct.org/download.php?id=" + str(tid) + "&passkey=bc4c91a9d3eea58b06393e45b34166db",cookies=cookies, stream=True)
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
