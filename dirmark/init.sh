#!/bin/sh

python -c "
print(len('hello,world'))
"

function echo_help
{
    if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] ; then
        cat <<EOF
s <tag_name> - Saves the current directory as "tag_name"
g <tag_name> - Goes (cd) to the directory associated with "tag_name"
p <tag_name> - Prints the directory associated with "tag_name"
d <tag_name> - Deletes the tag
l            - Lists all available tags
EOF
        kill -SIGINT $$
    fi
}

function s
{
    cat <<EOF
print('$*')
EOF
}

function excute
{
    python -c "$*"
}
