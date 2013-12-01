#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# This file containes the self defined initialized settings for shell.
# You can find the latest version on:
#       http://github.com/nkwsqyyzx/.sys.config.git
#
# Maintainer:  wsq
# Last Change: 2013-11-30 13:48:03
# Email:       nk.wangshuangquan@gmail.com
# Version:     0.1
#
# usage: source ~/$_CONFIG_BASE/common.sh
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

_CONFIG_BASE=$HOME/.sys.config

source $_CONFIG_BASE/settings.common.sh
source $_CONFIG_BASE/settings.git.sh
source $_CONFIG_BASE/settings.svn.sh

# this script is wrote to detect system.
source $_CONFIG_BASE/system.detect.sh

# system dependent settings
case $SYS_OS in
    linux )
        source $_CONFIG_BASE/platform.linux.sh
        ;;
    mac )
        source $_CONFIG_BASE/platform.mac.sh
        ;;
    windows_mingw )
        source $_CONFIG_BASE/platform.windows_mingw.sh
        ;;
    windows_cygwin )
        source $_CONFIG_BASE/platform.windows_cygwin.sh
        ;;
esac

case $SYS_OS in
    windows_* )
        # configure vim
        source $_CONFIG_BASE/ConfigureVim.sh
        source $_CONFIG_BASE/platform.windows_common.sh
        # windows terminal encoding
        source $_CONFIG_BASE/settings.locales.sh
        perfect
        ;;
esac
