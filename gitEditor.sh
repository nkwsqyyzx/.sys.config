#!/bin/sh

# $SYS_OS is from system.detect.sh in .sys.config

source ~/.sys.config/ConfigureVim.sh
case $SYS_OS in
    windows_mingw )
        FILE_PATH="$1"
        ;;
    windows_cygwin )
        FILE_PATH=`cygpath -a -w $1`
        ;;
esac
gvim "$FILE_PATH"
