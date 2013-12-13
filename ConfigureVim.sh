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
}

check_vim()
{
    if ! [[ -f "$gvimexe" ]] ; then
        echo i did not found vim in "$vimpath"
        return 1
    else
        return 0
    fi
}

ConfigureVim

gvim()
{
    check_vim
    if [[ $? -eq 0 ]] ; then
        "$gvimexe" $*
    fi
}

vim()
{
    check_vim
    if [[ $? -eq 0 ]] ; then
        "$vim" $*
    fi
}
