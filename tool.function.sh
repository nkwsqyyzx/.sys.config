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

# find file by file extension
function fe
{
    if [[ "$#" -eq 1 ]]; then
        find . -name "*.$1"
    elif [[ "$#" -eq 2 ]]; then
        find "$1" -name "*.$2"
    else
        echo "Useage:fe [DIRECTORY] <extension>"
    fi
}

function pulldb
{
    adb shell ls /data/data|grep "$*"|dos2unix|while read package;do
    (
        files=$(adb shell ls /data/data/$package/databases/|dos2unix|grep db$)
        [[ -n "$files" ]]  && echo "$files"|while read file;do adb pull /data/data/$package/databases/$file $package/$file;done
    );
    done
}

function pulllog() {
    adb shell ls /sdcard/\*.log\|sed 's/^\/sdcard\///g'\|grep "$*"|dos2unix|while read -r line;
    do
        file="/sdcard/$line"
        (adb pull "$file" "$line" && adb shell rm "$file")
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

function useUSB() {
    export ANDROID_SERIAL=$(adb devices|awk '/device$/{print $1}'|grep -v ":5555")
}

function usblogcat() {
    (export ANDROID_SERIAL=$(adb devices|awk '/device$/{print $1}'|grep -v ":5555") && logcat "$*")
}

function useGenymotion() {
    export ANDROID_SERIAL=$(adb devices|awk '/device$/{print $1}'|grep ":5555")
}

function genymotionlogcat() {
    (export ANDROID_SERIAL=$(adb devices|awk '/device$/{print $1}'|grep ":5555") && logcat "$*")
}
