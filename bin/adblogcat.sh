process_name=$1
extra_filter=$2

if [[ ! -p /tmp/pid_fifo ]]; then
    rm -rf /tmp/pid_fifo
    mkfifo /tmp/pid_fifo
fi

if [[ -z "$process_name" ]]; then
    echo "no process_name!"
    exit 1
fi

function start_adb_logcat() {
    sleep 1
    current_pid=$(cat /tmp/adb_logcat_old_pid)
    echo "start_adb_logcat $current_pid function begin"
    echo "$current_pid">/tmp/adb_logcat_old_pid
    pids=$(cat /tmp/pid_fifo)
    echo "start_adb_logcat monitoring pids $pids"
    echo "===================================================================================================================================================================================================================================================================================================================================================================================================================================================="

    cat <<EOF >/tmp/awk.ff
BEGIN {
    split("$pids", pid_array)
    for (i in pid_array) mm[pid_array[i]] = ""
}
(\$3 in mm) {print}
EOF

    if [[ -z "$extra_filter" ]]; then
        adb logcat -v color | awk -f /tmp/awk.ff
    else
        adb logcat -v color | awk -f /tmp/awk.ff | grep "$extra_filter"
    fi
}

process_id=$$

old_process="ssssssssssss"
while true; do
    new_process=$(adb shell ps | grep $process_name | sort -k2 | head -n 1 | awk '{print $2}')
#   echo "process_name ${process_name} new_process == old_process: $new_process==$old_process"
    if [[ -z "$new_process" ]]; then
        echo "process ${process_name} not found! wait for 5 seconds"
    else
        if [[ ${new_process} != "${old_process}" ]]; then
            # 干掉那些僵尸进程
            ps -f | awk '$3==1{print $2}' | xargs kill -9
            if [[ -f /tmp/adb_logcat_old_pid ]]; then
                kill -9 $(cat /tmp/adb_logcat_old_pid)
                sleep 1
            fi
            echo "while process got $new_process for $process_name"
            start_adb_logcat &
            subprocess_id=$!
            echo "${subprocess_id}">/tmp/adb_logcat_old_pid
#           echo "while process $process_id a.sh wait for subprocess_id:${subprocess_id}"
            old_process=$new_process
            adb shell ps | grep $process_name | awk '{print $2}' | tr -s '\n' ' ' >/tmp/pid_fifo
        fi
    fi
    sleep 5
done
