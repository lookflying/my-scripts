#!/bin/bash
tmp_file=/dev/shm/print_time_log
print_time > $tmp_file &
sleep 5
killall print_time
#mv $tmp_file .

