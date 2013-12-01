# ----------------------------HELPER FUNCTIONS--------------------------------

# the following functions refer to coto.thanks.i rewrite it because
# this article:
# http://stackoverflow.com/questions/394230/detect-the-os-from-a-bash-script
# advise use newer clearer syntax $(cmd) instead of backticks. see:
# https://github.com/coto/server-easy-install/blob/master/lib/core.sh

__lower_case(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

SYS_OS=`__lower_case $(uname)`

if [[ "${SYS_OS}" == mingw32_nt* ]]; then
    SYS_OS=windows_mingw
elif [[ "${SYS_OS}" == cygwin_nt* ]]; then
    SYS_OS=windows_cygwin
elif [[ "${SYS_OS}" = "darwin" ]]; then
    SYS_OS=mac
else
    SYS_OS=linux
fi

# export for other scripts
export SYS_OS
# ----------------------------HELPER FUNCTIONS--------------------------------
