#!/usr/bin/python
import sys
import os.path
import csv
def is_number(s):
	try:
		float(s)
		return True
	except ValueError:
		return False

def usage():
	print "usage:", sys.argv[0], " <filename> <period>" 
	exit(1)

if (len(sys.argv) == 3):
	name = sys.argv[1]
	period = sys.argv[2]
	if (not os.path.isfile(name) or not is_number(period)):
		usage()
	else:
	#	print "filename=", name, "\tperiod=", period
		begin = 0
		end = 0
		count = 0
		duration = 0
		for line in csv.reader(open(name), delimiter="\t"):
			if line:
				if (begin == 0):
					begin = float(line[1])
					end = begin + float(period)
				if (float(line[1]) < end):
					duration += float(line[3])
				else:
					count += 1
					print count, "\t", begin, "\t", end, "\t", duration
					begin = line[1]
					end += float(period)
					duration = float(line[3])

else:
	usage()
