#!/usr/bin/python
from PIL import Image
import sys

if len(sys.argv) == 3:
	filename = sys.argv[1]
	length = sys.argv[2]
	image = Image.open(filename)
	(width, height) =  image.size
	length = int(length)
	min_length = min(width, height)
	s_width = width * length / min_length
	s_height = height * length / min_length
	s_image = image.resize((s_width, s_height), Image.ANTIALIAS)
	s_image.save(filename)
