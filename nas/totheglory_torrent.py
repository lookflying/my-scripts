#!/usr/bin/python
import requests, shutil
import urllib
import os
import sys
import time
torrents_dir = "totheglory"
header_info = {
                "Cookie":"uid=50586; pass=faa6a5d10373dddd342da7a917250b95; CNZZDATA4085974=cnzz_eid%3D1121966193-1409988557-%26ntime%3D1412686873; __utma=230798618.1508608959.1409988555.1412686873.1412691585.7; __utmz=230798618.1409988555.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.2.1508608959.1409988555"
}
if not os.path.exists(torrents_dir):
	os.makedirs(torrents_dir);

def fetch(tid, retry):
	if retry > 10:
                print "fail to download " + str(tid)
		return
        #url ="http://totheglory.im/dl/" + str(tid) + "/4a5370be4bc7762aea7e9b79119e31e9"
        url ="http://totheglory.im/dl/"+ str(tid).strip().replace('\n', '') +  "/4a5370be4bc7762aea7e9b79119e31e9"
        print url
	r = requests.get(url, headers=header_info, stream=True)
#	r = requests.get("http://totheglory.im/dl/" + str(tid) + "/4a5370be4bc7762aea7e9b79119e31e9", stream=True)
	if r.status_code == 200:
		name = urllib.unquote(r.headers['Content-Disposition'].split(";")[1].strip().replace('filename=', ''))
		print name
		with open(torrents_dir + "/" + name, 'wb') as f:
			r.raw.decode_content = True
			shutil.copyfileobj(r.raw, f)
        else:
            print r.status_code
            time.sleep(retry + 1)
            fetch(tid, retry + 1)


line = sys.stdin.readline()
while line:
	print line
	fetch(line, 0)
	line = sys.stdin.readline()
