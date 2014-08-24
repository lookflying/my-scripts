#!/bin/bash
function show_confirm()
{
	echo "the following command are going to be executed!"
	echo "$@"
	read -n1 -p "Confirm?[Y/N]?" answer
	case $answer in
	Y|y)
		echo
		echo "Executing!"
		$@
		echo "Done";;
	N|n)
		echo
		echo "Cancelled!";;
	esac
}
if [ $# -eq 1 ]
then
	testfile=$1
	testname=${testfile%.*}

	show_confirm	rm -r $testname"_"*
fi
