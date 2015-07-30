# find file by name
function fn
{
    if [[ "$#" -eq 1 ]]; then
        find . -name "$1"
    elif [[ "$#" -eq 2 ]]; then
        find "$1" -name "$2"
    else
        echo "Useage:fn [DIRECTORY] <pattern>"
    fi
}

function pulldb
{
    for i in $(adb shell ls /data/data/$ANDROIDPRO/databases|dos2unix|grep '^message_\d\+\.db$');do adb pull "/data/data/$ANDROIDPRO/databases/$i";done
}

function pullLogAndDatabaseFromSD
{
    adb shell ls -al /sdcard/|dos2unix|grep '\b\<[0-9]\+\.\(log\|db\)$'|grep "$*"|while read -r line
    do
        file=$(echo $line|sed -e 's/  / /g' -e 's/^.*[0-9]\{4,4\}-[0-9: \-]\{12,12\}//g')
        name=$(echo $line|sed -e 's/  / /g' -e 's/^.*\([0-9]\{4,4\}-[0-9: \-]\{11,11\}\) \([0-9]*\).\(.*\)/\2_\1.\3/g' -e 's/[- :]/_/g')
        echo "pull $file as $name ..."
        (adb pull /sdcard/"$file" "$name") && (adb shell rm "/sdcard/$file")
    done
}

function deletelog
{
    adb shell ls -al /sdcard/|dos2unix|grep '\b\<[0-9]\+\.\(log\|db\)$'|grep "$*"|while read -r line
    do
        file=$(echo $line|sed -e 's/  / /g' -e 's/^.*[0-9]\{4,4\}-[0-9: \-]\{12,12\}//g')
        echo "delete $file ..."
        adb shell rm "/sdcard/$file"
    done
}

function lsdcard
{
    adb shell ls -al /sdcard/|dos2unix|grep '\b\<[0-9]\+.\(log\|db\)$'
}

function deletedb
{
    for i in $(adb shell ls /data/data/$ANDROIDPRO/databases|dos2unix|grep '^message_\d');do adb shell rm "/data/data/$ANDROIDPRO/databases/$i";done
}

function adblogcv
{
    adb logcat -C -v time $ANDROIDPRO|LANG=C LC_CTYPE=C sed -n -e '/LSH /p' -e '/AndroidRuntime/p' -e '/System.err/p' -e '/System.err.*Exception/p'
}

function adblogv
{
    adb logcat -v time|coloredlogcat.py
}
