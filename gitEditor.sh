#!/bin/sh

# $SYS_OS is from system.detect.sh in .sys.config

case $SYS_OS in
    windows_cygwin )
        FILE_PATH=`cygpath -a -w $1`
        ;;
    * )
        FILE_PATH="$1"
        ;;
esac
vim "$FILE_PATH"

case $SYS_OS in
    windows_* )
        # first configure vim path for windows
        source ~/.sys.config/ConfigureVim.sh
        gvim "$1"
        ;;
    * )
        vim "$1"
        ;;
esac
