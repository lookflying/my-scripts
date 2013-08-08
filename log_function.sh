#!/bin/bash

log_temp=test.log
log_column=1
log_column_count=0
log_temp2=test2.log
log_column_count2=0
function reset_log(){
    reset_time=`date +%Y%m%d%H%M%S`
    log_temp=test$$-$reset_time.log
    log_column_count=0
    log_column_count2=0
    log_column=1
    >$log_temp
    >$log_temp2
}

function set_log_column(){
    if [ $1 -gt 0 ]
    then
        log_column=$1
    else
        log_column=1
    fi
}
function print_log(){
    if [ $log_column_count -lt $log_column ]
    then
        echo -ne "$1\t" >> $log_temp
        log_column_count=$[$log_column_count + 1]
    else
        echo -ne "\n" >> $log_temp
        echo -ne "$1\t" >> $log_temp
        log_column_count=1
    fi
}

function print_log2(){
    if [ $log_column_count2 -lt $log_column ]
    then
        echo -ne "$1\t" >> $log_temp2
        log_column_count2=$[$log_column_count2 + 1]
    else
        echo -ne "\n" >> $log_temp2
        echo -ne "$1\t" >> $log_temp2
        log_column_count2=1
    fi
}

function save_log(){
    echo -ne "\n" >> $log_temp
    description=${1##*/}
    runday=`date +%Y%m%d`
    runtime=`date +%H%M%S`
    last_log_file=$runday-$runtime-$description.log
    mv $log_temp $last_log_file
    if [ $? -eq 0 ]
    then 
        echo $last_log_file is saved
    fi
}
