# thanks to https://github.com/huyng/bashmarks.git
#

DIRECTORIES=~/.DIRECTORIES
touch "$DIRECTORIES"

# load saved DIRECTORIES to memory
function _RESET
{
    export Saved_DIRECTORIES="$(cat "$DIRECTORIES")"
}

function _echo_help
{
    if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] ; then
        cat <<EOF
a - Add the current directory to the marks
g - Go (cd) to the saved directory
d - Deletes the directory item
l - Lists all directory items
EOF
        kill -SIGINT $$
    fi
}

function _bookmark_name_valid
{
    error_message=""
    if [ -z $1 ]; then
        #echo "note:you have added an empty taged directory"
        #for future develop
    elif [ "$1" != "$(echo $1 | sed 's/[^A-Za-z0-9_]//g')" ]; then
        error_message="bookmark name is not valid"
        echo $error_message
    else
        error_message="tag not supported now."
        echo $error_message
    fi
}

_RESET
# |tag|path
function a
{
    _echo_help $1
    _bookmark_name_valid "$@"
    if [ -z "$error_message" ]; then
        CURDIR=$(echo $PWD)
        r=$(echo $Saved_DIRECTORIES | grep -e "^$CURDIR\$")
        if [ ! -z "$r" ] ; then
            echo found $CURDIR
        else
            echo "|$1|$CURDIR" >> "$DIRECTORIES"
            _RESET
        fi
        unset CURDIR
    fi
}

function g
{
    cd "$1"
}

# return all diretoires in cached
function _l
{
    echo $Saved_DIRECTORIES | cut -d'|' -f3
}

# ZSH completion command
function _compzsh
{
    reply=("${(@f)$(_l)}")
}

# bind completion command for g,p,d to _comp
if [ $ZSH_VERSION ]; then
    compctl -K _compzsh a
    compctl -K _compzsh g
    compctl -K _compzsh p
    compctl -K _compzsh d
else
    echo the script just support zsh
fi

_tab_complete_dirmark()
{
    if [[ -z $BUFFER || "$BUFFER" = "g " ]] ; then
        BUFFER="g "
        zle end-of-line
        zle expand-or-complete
        zle expand-or-complete
        zle expand-or-complete
    else
        zle expand-or-complete
    fi
}
zle -N _tab_complete_dirmark
bindkey "\t" _tab_complete_dirmark
