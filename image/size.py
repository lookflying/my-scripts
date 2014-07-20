#!/usr/bin/python
from PIL import Image
import sys

if len(sys.argv) == 2:
	filename = sys.argv[1]
	image = Image.open(filename)
	print image.size
