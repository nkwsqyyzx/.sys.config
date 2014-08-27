function pulldb
{
    for i in $(adb shell ls /data/data/$ANDROIDPRO/databases|dos2unix|grep '^message_\d');do adb pull "/data/data/$ANDROIDPRO/databases/$i";done
}

function deletedb
{
    for i in $(adb shell ls /data/data/$ANDROIDPRO/databases|dos2unix|grep '^message_\d');do adb shell rm "/data/data/$ANDROIDPRO/databases/$i";done
}

function adblogcv
{
    adb logcat -C -v time $ANDROIDPRO|LANG=C LC_CTYPE=C sed -n -e '/LSH:/p' -e '/AndroidRuntime/p'
}

function adblogv
{
    adb logcat -v time|LANG=C LC_CTYPE=C sed -n -e '/LSH:/p' -e '/AndroidRuntime/p'
}
