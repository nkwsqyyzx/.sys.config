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

[[ "$SHELL_TYPE" == "bash" ]] && ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ "$SHELL_TYPE" == "zsh" ]] && ROOT="$(dirname $0)"

export _CONFIG_BASE="$ROOT"

# this script is wrote to detect system.
source $_CONFIG_BASE/system.detect.sh

# Linuxbrew PATH 早加载: 让后续 settings/*.sh (cd.sh 检查 autojump/fzf 等) 能看到 brew 安装的工具
if [[ "$SYS_OS" == "linux" && -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export PATH=$PATH:"$_CONFIG_BASE/bin/"

source $_CONFIG_BASE/settings.common.sh
source $_CONFIG_BASE/settings.all.sh

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
        source $_CONFIG_BASE/settings/locales.sh
        perfect
        ;;
esac
