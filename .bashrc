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

# ignore and delete duplicate
export HISTCONTROL=ignoreboth:erasedups
# ignore the following commands
export HISTIGNORE="[ ]*:&:bg:fg:exit:history"
# the filesize
export HISTFILESIZE=1000000000
# the history items count
export HISTSIZE=1000000
# export the editor for svn commit
export SVN_EDITOR=vim
# append history

if which shopt >/dev/null; then
    shopt -s histappend
fi
# after the command finish,append it
PROMPT_COMMAND="history -n;history -a;$PROMPT_COMMAND"

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
alias st='svn st'
alias svnremovedeletedfiles="svn st|grep '^!'|sed 's/^! *//'|xargs -I% svn rm %"

# good experience with ls.
alias la='ls -al'

# good experience with cd.
alias .='cd -'
alias ..='cd ..'
alias ...='cd ../..'

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
        SYS_OS=windows_mingw
    elif [[ "${SYS_OS}" == cygwin_nt* ]]; then
        SYS_OS=windows_cygwin
    elif [[ "${SYS_OS}" = "darwin" ]]; then
        SYS_OS=mac
    else
        SYS_OS=linux
    fi
}
__sys_info

# ----------------------------HELPER FUNCTIONS--------------------------------

# the platform specified settings.
# ---------------------------------NIX PLATFORM-------------------------------
if [[ "${SYS_OS}" = "linux" ]] ; then
    alias o='nautilus'
    alias oo='o .'
    alias ou='xdg-open'
    alias ll='ls -al --color=auto'
fi
# ---------------------------------MAC PLATFORM-------------------------------

# the platform specified settings.
# ---------------------------------MAC PLATFORM-------------------------------
if [[ "${SYS_OS}" = "mac" ]] ; then
    alias o='open'
    alias oo='open .'
    alias ou='open'
    alias ll='ls -alG'
    alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'
fi
# ---------------------------------MAC PLATFORM-------------------------------

# ---------------------------------WIN PLATFORM-------------------------------
function ConfigureVim () {
    gvimexe="$PROGRAMFILES"/Vim/vim74/gvim.exe
    if [[ -f "$gvimexe" ]] ; then
        alias gvim='"$gvimexe"'
    else
        gvimexe="$PROGRAMFILES"/Vim/vim73/gvim.exe
        if [[ -f "$gvimexe" ]] ; then
            alias gvim='"$gvimexe"'
        else
            echo 'i did not found gvim in "$PROGRAMFILES"/Vim/'
        fi
    fi
}

# ---------------------------------MINGW PLATFORM-----------------------------
if [[ "${SYS_OS}" = "windows_mingw" ]] ; then
    export LESSCHARSET=utf-8
    alias ls="ls --show-control-chars"
    alias o='start'
    alias oo='start .'
    alias ou='start'
    alias ll='ls --color=auto -al'
    ConfigureVim
fi

# ---------------------------------CYGWIN PLATFORM----------------------------
if [[ "${SYS_OS}" = "windows_cygwin" ]] ; then
    export LESSCHARSET=utf-8
    export CYGWIN=nodosfilewarning
    alias ls="ls --show-control-chars"
    alias o='cygstart'
    alias oo='o .'
    alias ou='o'
    alias ls='ls --color=auto'
    alias ll='ls -al'
    ConfigureVim
fi
# ---------------------------------WIN PLATFORM-------------------------------

# -------------------------DEPENDENT SETTINGS---------------------------------
# contains some alias and settings dependening on previous ones.
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

# alias to open favorite sites.
alias ogoogle='ou https://www.google.com.tw'
alias oengoogle='ou https://www.google.com/ncr'
alias oweibo='ou http://weibo.com'
# -------------------------DEPENDENT SETTINGS---------------------------------
