if [[ "$SHELL_TYPE" == "zsh" ]]; then
    # ignore and delete duplicate
    export HISTCONTROL=ignoreboth
    # ignore the following commands
    export HISTIGNORE="[ ]*:&:bg:fg:exit:history"
    # the filesize
    export HISTFILESIZE=1000000000
    # the history items count
    export HISTSIZE=1000000
    # append history
    if which shopt >/dev/null 2>&1; then
        shopt -s histappend
    fi
    # after the command finish,append it
    PROMPT_COMMAND="history -n;history -a;$PROMPT_COMMAND"
fi

# thanks to oreilly,this is a really good alias.
# http://www.oreillynet.com/onlamp/blog/2007/01/whats_in_your_bash_history.html
# Compress the cd, ls -l series of commands.
function cl () {
    if [ $# = 0 ]; then
        cd && ll
    else
        cd "$*" && ll
    fi
}

function mkcd () {
    mkdir -p "$@" && eval cd "\"\$$#\"";
}

function sct() {
    local i=$1
    if [[ $i -gt $(date +"%s")*100 ]]; then i=$i/1000; fi
    sqlite3 "" "select datetime($i, 'unixepoch', 'localtime');" 2>>/dev/null | awk '/[0-9]+-/{print $0}'
}

function gvimServer() {
    local server=$(gvim --serverlist|head -1)
    [[ -z "$server" ]] && server='VIM'
    gvim --servername "$server" --remote-tab-silent "$*"
}

# autojump
case $SYS_OS in
    linux)
        [[ -f "$HOME/.autojump/etc/profile.d/autojump.sh" ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
    ;;
    mac)
        if [[ -f "$HOME"/.autojump/etc/profile.d/autojump.sh ]]; then
            source "$HOME"/.autojump/etc/profile.d/autojump.sh
        elif [[ -f "$(brew --prefix)"/etc/profile.d/autojump.sh ]]; then
            source "$(brew --prefix)"/etc/profile.d/autojump.sh
        fi
    ;;
esac
