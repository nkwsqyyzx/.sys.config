#!/bin/sh

# $SYS_OS is from .bashrc in conf

source ~/conf/ConfigureVim.sh
case $SYS_OS in
    windows_mingw )
        FILE_PATH="$1"
        ;;
    windows_cygwin )
        FILE_PATH=`cygpath -a -w $1`
        ;;
esac
gvim "$FILE_PATH"
