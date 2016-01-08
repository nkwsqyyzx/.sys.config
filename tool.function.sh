# find file by name
function fn()
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
function fe()
{
    if [[ "$#" -eq 1 ]]; then
        find . -name "*.$1"
    elif [[ "$#" -eq 2 ]]; then
        find "$1" -name "*.$2"
    else
        echo "Useage:fe [DIRECTORY] <extension>"
    fi
}

# find & gvim file by file name pattern
function gfe()
{
    if [[ "$#" -eq 1 ]]; then
        find . -name "$1"|while read -r file;do (gvim --servername server --remote-tab-silent "$file");done
    elif [[ "$#" -eq 2 ]]; then
        find "$1" -name "$2"|while read -r file;do (gvim --servername server --remote-tab-silent "$file");done
    else
        echo "Useage:gfe [DIRECTORY] <pattern>"
    fi
}

function pulldb()
{
    adb shell ls /data/data|grep "$*"|dos2unix|while read package;do
    (
        files=$(adb shell ls /data/data/$package/databases/|dos2unix|grep db$)
        [[ -n "$files" ]]  && echo "$files"|while read file;do adb pull /data/data/$package/databases/$file $package/$file;done
    );
    done
}

function pulllog()
{
    adb shell ls /sdcard/\*.log\|grep "$*"|dos2unix|while read -r line;
    do
        file="$line"
        localFile=$(echo "$line"|sed 's/^\/sdcard\///g')
        (adb pull "$file" "$localFile" && adb shell rm "$file")
    done
}

function deletelog()
{
    adb shell ls -al /sdcard/|dos2unix|grep '\b\<[0-9]\+\.\(log\|db\)$'|grep "$*"|while read -r line
    do
        file=$(echo $line|sed -e 's/  / /g' -e 's/^.*[0-9]\{4,4\}-[0-9: \-]\{12,12\}//g')
        echo "delete $file ..."
        adb shell rm "/sdcard/$file"
    done
}

function lsdcard()
{
    adb shell ls -al /sdcard/|dos2unix|grep '\b\<[0-9]\+.\(log\|db\)$'
}

function deletedb()
{
    [[ -z "$*" ]] && echo "must specify package pattern" && kill -INT $$
    adb shell ls /data/data|grep "$*"|dos2unix|while read package;do
        echo "remove $package's database."
        adb shell rm -rf /data/data/$package/databases
    done
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

function syncAndroidDeviceTime() {
    local time=$(date '+%G%m%d.%H%M%S')
    adb shell "su 0 date -s $time"
}

function androidScreen() {
    adb shell screencap -p /sdcard/androidScreen.png
    adb pull /sdcard/androidScreen.png
    adb shell rm /sdcard/androidScreen.png
}
