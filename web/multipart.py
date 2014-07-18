#!/usr/bin/python
from poster.encode import multipart_encode
from poster.streaminghttp import register_openers
import urllib2
import json

#url = "http://pictrail.tk:8000/"
url = "http://203.195.155.219:8000/"
register_openers()
data = {'hello': 'world', 'here': 'there',}
json_data = json.dumps(data)

datagen, headers = multipart_encode({"json": json_data})
#datagen, headers = multipart_encode({"script1": open(__file__, "rb"), "json": json_data})
#datagen, headers = multipart_encode({"script1": open(__file__, "rb")})

request = urllib2.Request(url, datagen, headers)

print urllib2.urlopen(request).read()
