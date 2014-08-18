function pulldb
{
    for i in $(adb shell ls /data/data/$ANDROIDPRO/databases|dos2unix|grep '^\d');do adb pull "/data/data/$ANDROIDPRO/databases/$i";done
}

function deletedb
{
    for i in $(adb shell ls /data/data/$ANDROIDPRO/databases|dos2unix|grep '^\d');do adb shell rm "/data/data/$ANDROIDPRO/databases/$i";done
}

function adblogcv
{
    adb logcat -C -v time $ANDROIDPRO|LANG=C LC_CTYPE=C sed -e '/DexOpt/d' -e '/dalvikvm/d' -e '/I\/System.out/d' -e '/PackageManager/d' -e '/W\/System.err/d' -e '/[IW]\/ActivityManager/d' -e '/bmpCache/d'
}
