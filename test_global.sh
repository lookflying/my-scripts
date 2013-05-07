#!/bin/bash
component_name=""
function change_component(){
	component_name=$1
}

echo "$component_name"
change_component "hello"
echo "$component_name"
change_component "world"
echo "$component_name"
