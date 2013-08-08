#!/bin/bash
command_self=$0
transcode_dir="transcoded"
throughput_time_log_key_word="-throughput-time-"
function transcode(){
    if [ $# -eq 4 ]
    then
        input_video=$1
		video_name=${input_video##*/}
        threads=$2
        bitrate=$3
        resolution=$4
        case $resolution in
        "480x360")
            filter=364.8:10.8;;
        "640x480")
            filter=486.4:14.4;;
        "720x640")
            filter=547.2:19.2;;
        *)
            filter="";;
        esac
        
        if [ ! -d $transcode_dir ]
        then
            mkdir $transcode_dir
        fi
        ffmpeg -y -i $input_video -threads $threads -vcodec libx264 -vf "movie=logo.png [logo1];[in][logo1] overlay=$filter [out]" -acodec libaacplus -b $bitrate -s $resolution -level 31 -async 2 -ab 32k -ar 44100 -ac 2 -r 25 -f mp4 $transcode_dir/$video_name-$thread$bitrate$resolution$$.mp4
    fi
}

function clear_transcoded_file(){
    rm -rf $transcode_dir/*
}

function transcode_in_mode(){
    if [ $# -eq 3 ]
    then
        transcode_file=$1
        transcode_thread=$2
        transcode_mode=$3
        case $transcode_mode in
        0)
            transcode $transcode_file $transcode_thread 250k 480x360;;
        1)
            transcode $transcode_file $transcode_thread 450k 480x360;;
        2)
            transcode $transcode_file $transcode_thread 600k 640x480;;
        3)
            transcode $transcode_file $transcode_thread 1200k 720x640;;
        esac
    fi
}

#transcode $@
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
    description=${1##*./}
    runday=`date +%Y%m%d`
    runtime=`date +%H%M%S`
    last_log_file=$runday-$runtime-$description.log
    mv $log_temp $last_log_file
    if [ $? -eq 0 ]
    then 
        echo $last_log_file is saved
    fi
}

function measure_time(){
    TIMEFORMAT=%R
    exec 3>&1 4>&2
    { time $@ 1>&3 2>&4; } 2>&1 | awk '{print $NF}'
    exec 3>&- 4>&-


}

function test_threads(){
    video=$1
    min_thread=$2
    max_thread=$3
    reset_log
    set_log_column 4
    for ((i = $min_thread;i <= $max_thread; ++i))
    do
        print_log `measure_time transcode_in_mode $video $i 0`
        print_log `measure_time transcode_in_mode $video $i 1`
        print_log `measure_time transcode_in_mode $video $i 2`
        print_log `measure_time transcode_in_mode $video $i 3`
    done
    save_log "$video-threads-$min_thread-$max_thread"
}

#get file size in bytes
function get_file_size(){
    file=$1
    echo `ls -l $file|awk '{print $5}'`
}

function measure_throughput(){
    file=$1
    log_file=$2
    file_size=`get_file_size $file`
    cat $log_file|awk -v file_size=$file_size '
    function cals_throughput(file_size, tasks, used_time){
        return file_size * tasks / used_time / 1024 / 1024
    }
    {
        if(NF >=2){
            tasks=$1
            printf "%d\t", tasks
            for( i = 2; i <= NF; i++){
                throughput=cals_throughput(file_size, tasks, $i)
                printf "%f\t", throughput
            }
            printf "\n"
        }
    }'

}

function measure_two_pass_percentage(){
    total_time=`cat two_pass_mode_time*.log|awk 'BEGIN{sum=0}{sum+=$1}END{print sum}'`
    ffmpeg_time=`cat ffmpeg_time*.log|awk 'BEGIN{sum=0}{sum+=$1}END{print sum}'`
    mencoder_percentage=`echo "scale=3; ($total_time - $ffmpeg_time) / $total_time * 100"|bc`
    rm -rf two_pass_mode_time*.log
    rm -rf ffmpeg_time*.log
    echo -n "$mencoder_percentage"
}

function save_percentage_log(){
    echo -ne "\n" >> $log_temp2
    description=${1##*./}
    runday=`date +%Y%m%d`
    runtime=`date +%H%M%S`
    percentage_log_file=$runday-$runtime-$description-mencoder-percentage.log
    mv $log_temp2 $percentage_log_file
    if [ $? -eq 0 ]
    then 
        echo $percentage_log_file is saved
    fi
}

function save_throughput_log(){
    file=$1
    log_file=$2
    prefix=${log_file%$throughput_time_log_key_word*}
    suffix=${log_file#*$throughput_time_log_key_word}
    target_log_file=$prefix-throughput-result-$suffix
    measure_throughput $file $log_file|tee $target_log_file
}

function test_multi_task(){
    file=$1
    thread=$2
    task=$3
    mode=$4
    for ((i= 1; i <= $task; ++i))
    do
        $command_self "transcode_mode" $file $thread $mode &
    done
    wait
}

function test_throughput(){
    video=$1
    threads=$2
    max_tasks=$3
    step=$4
    reset_log
    set_log_column 5
    for ((i = 0; i <= $max_tasks; i += $step))
    do
        task=$i
        if [ $task -eq 0 ]
        then 
            task=1
        fi
        print_log $task
        print_log `measure_time test_multi_task $video $threads $task 0`
        print_log `measure_time test_multi_task $video $threads $task 1`
        print_log `measure_time test_multi_task $video $threads $task 2`
        print_log `measure_time test_multi_task $video $threads $task 3`
    done
    save_log "$video$throughput_time_log_key_word$threads-thread-1-$max_tasks-task"
    save_throughput_log $video $last_log_file
    clear_transcoded_file
}


function two_pass_mode(){
    local video=$1
    local mencoder_file=${1##*/}-mencoder$$.avi
    local threads=$2
    local mode=$3
    mencoder $video -oac mp3lame -lameopts abr:br=56 -channels 2 -srate 22050 -channels 2 -ovc xvid -xvidencopts bitrate=1000 -ofps 25 -of avi -o $transcode_dir/$mencoder_file >& /dev/null
    echo `measure_time transcode_in_mode $transcode_dir/$mencoder_file $threads $mode` > ffmpeg_time$$.log
}

function test_multi_task_two_pass(){
    file=$1
    thread=$2
    task=$3
    mode=$4
    for ((i= 1; i <= $task; ++i))
    do
        $command_self "two_pass_mode" $file $thread $mode &
    done
    wait
}

function test_two_pass_throughput(){
    video=$1
    threads=$2
    max_tasks=$3
    step=$4
    reset_log
    set_log_column 5
    for ((i = 0; i <= $max_tasks; i += $step))
    do
        task=$i
        if [ $task -eq 0 ]
        then 
            task=1
        fi
        print_log $task
        print_log2 $task
        measure_two_pass_percentage
        print_log `measure_time test_multi_task_two_pass $video $threads $task 0`
        print_log2 `measure_two_pass_percentage`
        print_log `measure_time test_multi_task_two_pass $video $threads $task 1`
        print_log2 `measure_two_pass_percentage`
        print_log `measure_time test_multi_task_two_pass $video $threads $task 2`
        print_log2 `measure_two_pass_percentage`
        print_log `measure_time test_multi_task_two_pass $video $threads $task 3`
        print_log2 `measure_two_pass_percentage`
    done
    save_log "$video-two-pass$throughput_time_log_key_word$threads-thread-1-$max_tasks-task"
    save_percentage_log "$video-two-pass$threads-thread-1-$max_tasks-task"
    save_throughput_log $video $last_log_file
    clear_transcoded_file

}

video_file_type="mp4 mpg wmv avi flv"
#main
command=$1
if [ $# -eq 2 ]
then
    case $command in
    "measure_throughput_dir")
        dir=$2
        for file_type in $video_file_type
        do
            files=`ls $dir/*.$file_type`
            for file in $files
            do
                filename=${file##*/}
                logs=`ls $dir|grep "$filename-throughput-time-"`
                for origin_log in $logs
                do
                    save_throughput_log $file $origin_log
                done
            done
        done
        ;;
    esac
elif [ $# -eq 3 ]
then
    case $command in
    "measure_throughput")
        file=$2
        log_file=$3
        save_throughput_log $file $log_file
    ;;
    esac
elif [ $# -eq 4 ]
then
    case $command in
    "threads")
        file=$2
        test_threads $file $3 $4
        ;;
    "threads_dir")
        dir=$2
        for file_type in $video_file_type
        do
            files=`ls $dir/*.$file_type`
            for file in $files
            do
                test_threads $file $3 $4    
            done
        done
        ;;
    "transcode_mode")
        file=$2
        thread=$3
        mode=$4
        transcode_in_mode $file $thread $mode
        ;;
    "two_pass_mode")
        file=$2
        thread=$3
        mode=$4
        echo `measure_time two_pass_mode $file $thread $mode` > two_pass_mode_time$$.log
        ;;
    esac
elif [ $# -eq 5 ]
then
    case $command in    
    "throughput")
        file=$2
        thread=$3
        max_task=$4
        step=$5
        test_throughput $file $thread $max_task $step
        ;;
    "throughput_dir")
        dir=$2
        thread=$3
        max_task=$4
        step=$5
        for file_type in $video_file_type
        do
            files=`ls $dir/*.$file_type`
            for file in $files
            do
                test_throughput $file $thread $max_task $step    
            done
        done
        ;;
     "two_pass_throughput")
        file=$2
        thread=$3
        max_task=$4
        step=$5
        test_two_pass_throughput $file $thread $max_task $step 
     ;;
    "two_pass_throughput_dir")
        dir=$2
        thread=$3
        max_task=$4
        step=$5
        for file_type in $video_file_type
        do
            files=`ls $dir/*.$file_type`
            for file in $files
            do
                test_two_pass_throughput $file $thread $max_task $step    
            done
        done
        ;;
    esac
else
    echo "usage: $0 \"threads\" file min_thread max_thread"
    echo "usage: $0 \"threads_dir\" dir min_thread max_thread"
    echo "uasge: $0 \"transcode_mode\" file thread mode"
    echo "usage: $0 \"throughput\" file thread max_task step"
    echo "usage: $0 \"throughput_dir\" dir thread max_task step"
    echo "usage: $0 \"measure_throughput\" file log_file"
    echo "usage: $0 \"measure_throughput_dir\" dir"
    echo "usage: $0 \"two_pass_mode\" file thread mode"
    echo "usage: $0 \"two_pass_throughput\" file thread max_task step"
    echo "usage: $0 \"two_pass_throughput_dir\" dir thread max_task step"

fi

