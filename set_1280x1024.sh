#/bin/bash
xrandr --newmode `cvt 1280 1024 60|grep Modeline|awk '{$1="";print $0}'`
xrandr --addmode VGA1 `cvt 1280 1024 60|grep Modeline|awk '{print $2}'`
xrandr --output VGA1 --mode `cvt 1280 1024 60|grep Modeline|awk '{print $2}'`
