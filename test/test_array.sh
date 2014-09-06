#!/bin/bash
declare -a a
a+=("abc")
a+=("def")
echo $a
echo array content = ${a[*]} '${a[*]}'
echo array indexes = ${!a[*]} '${!a[*]}'
echo array content = ${a[@]} '${a[@]}'
echo array indexes = ${!a[@]} ' ${!a[@]}'
echo array size = ${#a[@]} '${#a[@]}'
