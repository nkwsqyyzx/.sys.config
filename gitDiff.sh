case $SYS_OS in
    windows_mingw )
        DIFFMERGE_PATH="/c/Program Files/SourceGear/Common/DiffMerge/sgdm.exe"
        ;;
    windows_cygwin )
        DIFFMERGE_PATH='C:\\Program Files\\SourceGear\\Common\\DiffMerge\\sgdm.exe'
        ;;
    * )
        echo 'you must config diffmerge path for your system.'
        ;;
esac

"$DIFFMERGE_PATH" $*
