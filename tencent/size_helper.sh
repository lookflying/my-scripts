#!/bin/bash
if [ $# -ge 1 ]
then
	image=$1
	option=$2
	width=`identify $image|awk 'BEGIN{FS=" |x"}{print $3}'`
	height=`identify $image|awk 'BEGIN{FS=" |x"}{print $4}'`
	e_width=$[( $width + 7) / 8 * 8] 
	e_height=$[( $height + 7) / 8 * 8]
	m_width=$[$e_width / 2]
	m_height=$[$e_height / 2]
	t_width=`expr $width / 2`
	t_height=`expr $height / 2`
	#echo $image
	case $option in
	"e"|"extend")
		echo $e_width"x"$e_height
		;;
	"m")
		echo $m_width"x"$m_height
		;;
	"t"|"target")
		echo $t_width"x"$t_height
		;;
	*)
		echo $width"x"$height
	esac
else
	echo usage: $0 image option
fi

