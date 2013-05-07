#/bin/bash
if [ $# -eq 1 ]
then
	number=$1
else
	number=1
fi
xrandr --newmode `cvt 1280 1024 60|grep Modeline|awk '{$1="";print $0}'`
xrandr --addmode VGA$number `cvt 1280 1024 60|grep Modeline|awk '{print $2}'`
xrandr --output VGA$number --mode `cvt 1280 1024 60|grep Modeline|awk '{print $2}'`
