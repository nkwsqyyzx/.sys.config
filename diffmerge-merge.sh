#!/bin/sh

localPath="$2"
basePath="$1"
remotePath="$3"
resultPath="$4"

if [ ! -f $basePath ]
then
    basePath="~/diffmerge-empty"
fi

~/.sys.config/diffmerge-diff.sh --merge --result="$resultPath" "$localPath" "$basePath" "$remotePath" --title1="Mine" --title2="Merged: $4" --title3="Theirs"
