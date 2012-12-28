#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# This file containes the self defined initialized settings for shell.
# You can find the latest version on:
#       http://github.com/nkwsqyyzx/conf/
#
# Maintainer:  wsq
# Last Change: 2012-12-18 17:12:33
# Email:       nk.wangshuangquan@gmail.com
# Version:     0.1
#
# usage: source ~/conf/.bashrc
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


# ----------------------------COMMON SETTINGS---------------------------------

# good experience with git.
alias g='git'
alias gs='git status'
alias gg='git status'
alias gc='git commit'
alias gca='git commit -a'
alias ga='git add'
alias go='git checkout'
alias gb='git branch'
alias gm='git merge'
alias gd="git diff"

# good experience with svn.
alias up='svn up'

# good experience with ls.
alias la='ls -al'

# thanks to oreilly,this is a really good alias.
# http://www.oreillynet.com/onlamp/blog/2007/01/whats_in_your_bash_history.html
# Compress the cd, ls -l series of commands.
alias lc="cl"
function cl () {
   if [ $# = 0 ]; then
      cd && ll
   else
      cd "$*" && ll
   fi
}

# ----------------------------COMMON SETTINGS---------------------------------

# ----------------------------HELPER FUNCTIONS--------------------------------

# the following functions refer to coto.thanks.i rewrite it because
# this article:
# http://stackoverflow.com/questions/394230/detect-the-os-from-a-bash-script
# advise use newer clearer syntax $(cmd) instead of backticks. see:
# https://github.com/coto/server-easy-install/blob/master/lib/core.sh

__lower_case(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

__sys_info(){
    SYS_OS=$(__lower_case $(uname))
    SYS_KERNEL=$(uname -r)
    SYS_MACH=$(uname -m)

    # TODO.fix me when in mingw32 and other linux.
    if [[ "${SYS_OS}" == mingw32_nt* ]]; then
        SYS_OS=windows
    elif [[ "${SYS_OS}" = "darwin" ]]; then
        SYS_OS=mac
    else
        SYS_OS=linux
    fi
}
__sys_info

# ----------------------------HELPER FUNCTIONS--------------------------------

# the platform specified settings.
# ---------------------------------MAC PLATFORM-------------------------------
if [[ "${SYS_OS}" = "mac" ]] ; then
    alias o='open'
    alias oo='open .'
    alias ll='ls -alG'
    alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'
fi
# ---------------------------------MAC PLATFORM-------------------------------

# ---------------------------------WIN PLATFORM-------------------------------
if [[ "${SYS_OS}" = "windows" ]] ; then
    export LESSCHARSET=utf-8
    alias ls="ls --show-control-chars"
    alias o='start'
    alias oo='start .'
    alias ll='ls --color=auto -al'
    alias gvim='/c/Program\ Files/Vim/vim73/gvim'
fi
# ---------------------------------WIN PLATFORM-------------------------------
