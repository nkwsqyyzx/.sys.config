function pulldb() {
    adb shell ls /data/data|grep "$*"|dos2unix|while read package;do
    (
        local files=$(adb shell ls /data/data/$package/databases/|dos2unix|grep db$)
        [[ -n "$files" ]]  && echo "$files"|while read file;do adb pull /data/data/$package/databases/$file $package/$file;done
    );
    done
}

function pulllog() {
    adb shell ls /sdcard/\*.log\|grep "$*"|dos2unix|while read -r line;
    do
        local file="$line"
        local localFile=$(echo "$line"|sed 's/^\/sdcard\///g')
        (adb pull "$file" "$localFile" && adb shell rm "$file")
    done
}

function deletelog() {
    adb shell ls -al /sdcard/|dos2unix|grep '\b\<[0-9]\+\.\(log\|db\)$'|grep "$*"|while read -r line
    do
        local file=$(echo $line|sed -e 's/  / /g' -e 's/^.*[0-9]\{4,4\}-[0-9: \-]\{12,12\}//g')
        echo "delete $file ..."
        adb shell rm "/sdcard/$file"
    done
}

function lsdcard() {
    adb shell ls -al /sdcard/|dos2unix|grep '\b\<[0-9]\+.\(log\|db\)$'
}

function deletedb() {
    [[ -z "$*" ]] && echo "must specify package pattern" && kill -INT $$
    adb shell ls /data/data|grep "$*"|dos2unix|while read package;do
        echo "remove $package's database."
        adb shell rm -rf /data/data/$package/databases
    done
}

function useUSB() {
    export ANDROID_SERIAL=$(adb devices|awk '/device$/{print $1}'|grep -v -e ":5555" -v -e "emulator-")
}

function usblogcat() {
    (export ANDROID_SERIAL=$(adb devices|awk '/device$/{print $1}'|grep -v -e ":5555" -v -e "emulator-") && logcat "$*")
}

function useGenymotion() {
    export ANDROID_SERIAL=$(adb devices|awk '/device$/{print $1}'|grep -e ":5555" -e "emulator-")
}

function genymotionlogcat() {
    (export ANDROID_SERIAL=$(adb devices|awk '/device$/{print $1}'grep -e ":5555" -e "emulator-") && logcat "$*")
}

function syncAndroidDeviceTime() {
    local time=$(date '+%G%m%d.%H%M%S')
    adb shell "su 0 date -s $time"
}

function asnapshot() {
    local fname="snapshot_$(date|sed 's/[^0-9]//g').png"
    adb shell screencap -p /sdcard/asnapshot.png
    local file=$(adb shell "ls /sdcard/asnapshot.png 2>/dev/null")
    [[ -z "$file" ]] && sleep 1 && adb shell screencap -p /sdcard/asnapshot.png
    adb pull /sdcard/asnapshot.png "$fname"
    adb shell rm /sdcard/asnapshot.png
    open "$fname"
}

function device_proxy () {
    local BASEDIR="$HOME/.sys.config"
    local file=""
    [[ -d "$BASEDIR/bin" ]] || mkdir "$BASEDIR/bin"
    if [[ "x$1" = "xon" ]]; then
        file="$BASEDIR/bin/proxy_on"
        [[ -f "$2" ]] && file="$2"
    elif [[ "x$1" = "xoff" ]]; then
        file="$BASEDIR/bin/proxy_off"
    elif [[ "x$1" = "xbackup" ]]; then
        if [[ "x$2" == "xoff" ]]; then
            file="$BASEDIR/bin/proxy_off"
        else
            file="$BASEDIR/bin/proxy_on"
            [[ -n "$3" ]] && file="$3"
        fi
        echo "backup device proxy settings to $file"
        adb pull /data/misc/wifi/ipconfig.txt "$file"
        return 0
    fi
    if [[ -z "$file" ]]; then
        echo "Usage device_proxy [on|off|backup [on|off]]"
        kill -INT $$
    fi
    adb shell svc wifi disable
    adb push "$file" /data/misc/wifi/ipconfig.txt
    adb shell svc wifi enable
}

function akill() {
    adb shell ps\|grep "$1" | column 2| xargs adb shell kill
}

function apackagename() {
    aapt dump badging "$1"|grep "^package:"|sed "s/ /_/g"|sed "s/'/ /g"|awk '{print $2}'
}

function ainstall() {
    if [[ -f "$1" ]]; then
        local fname="$1"
    else
        local fname="$(date|sed 's/[^0-9]//g').apk"
        wget -O "$fname" "$1"
    fi
    ([[ -n "$(adb install -r $fname|grep '^Failure')" ]] && (n=`apackagename $fname` && (echo "remove $n first!!!" && adb uninstall $n) && adb install $fname))
}

function ainput() {
    adb shell input text "$*"
}

if [[ -n "${ANDROID_HOME}" ]]; then
    export PATH="$PATH:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin"
    tools_dir=''
    for dir in "${ANDROID_HOME}"/build-tools/*; do
        if [[ -z "${tools_dir}" ]]; then
            tools_dir="${dir}"
        else
            if [[ "${dir}" > "${tools_dir}" ]]; then
                tools_dir="${dir}"
            fi
        fi
    done
    if [[ -f "${tools_dir}/aapt" ]]; then
        export PATH="$PATH:${tools_dir}"
    else
        echo "No android build tools found, last known path:${tools_dir}!"
    fi

    if [[ -d "${ANDROID_HOME}/ndk" ]]; then
        export ANDROID_NDK_HOME="${ANDROID_HOME}/ndk"
    fi
fi

function monitor_top_activity() {
    oldActvity=""
    displayName=""
    currentActivity=$(adb shell dumpsys window windows | grep -E 'mCurrentFocus')
    while true; do
        if [[ $oldActvity != $currentActivity && $currentActivity != *"=null"* ]]; then
            displayName=${currentActivity##* }
            displayName=${displayName%%\}*}
            displayName=${displayName//\// }
            echo $(date -R "+%Y-%m-%d %H:%M:%S") "$displayName"
            oldActvity=$currentActivity
        fi
        currentActivity=$(adb shell dumpsys window windows | grep -E 'mCurrentFocus')
        sleep 1
    done
}

function enable_wifi_debug() {
    echo "setting port to 5555, take 2 seconds... ..."
    adb shell setprop service.adb.tcp.port 5555
    adb tcpip 5555
    sleep 2
    device_ip=$(adb shell ifconfig wlan0 | awk '/inet addr:/{print $0}' | awk -F: '{print $2}' | awk '{print $1}')
    echo "WiFi debug enable at device ip ${device_ip}"
}
