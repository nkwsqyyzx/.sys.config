function pulldb
{
    for i in $(adb shell ls /data/data/$ANDROIDPRO/databases|dos2unix|grep '^\d');do adb pull "/data/data/$ANDROIDPRO/databases/$i";done
}

function deletedb
{
    for i in $(adb shell ls /data/data/$ANDROIDPRO/databases|dos2unix|grep '^\d');do adb shell rm "/data/data/$ANDROIDPRO/databases/$i";done
}
