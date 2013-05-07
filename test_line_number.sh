#!/bin/bash
function print_line_number(){
	echo "call from $1"
}

print_line_number $LINENO
