#!/bin/sh

function ConfigureVim()
{
    vimpath="$PROGRAMFILES"/Vim/
    if ! [[ -d "$vimpath" ]] ; then
        vimpath="$PROGRAMFILES (x86)"/Vim/
    fi

    vimversion=vim74
    if ! [[ -d "$vimpath"/$vimversion ]] ; then
        vimversion=vim73
    fi

    gvimexe="$vimpath"/$vimversion/gvim.exe
    vimexe="$vimpath"/$vimversion/vim.exe
    if [[ -f "$gvimexe" ]] ; then
        alias gvim='"$gvimexe"'
        alias vim='"$vimexe"'
    else
        echo i did not found vim in "$vimpath"
    fi
}

ConfigureVim
