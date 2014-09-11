#!/bin/bash
pid=`pidof trace-cmd|awk '{print $NF}'`
kill -2 $pid

