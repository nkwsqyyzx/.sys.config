# good experience with git.
alias ga='git add'
alias gai='git add -i'
alias gap='git add -p'
alias gau='git add -u'
alias gb='git branch'
alias gc='git commit'
alias gca='git commit -a'
alias gd='git diff'
alias gdt='git difftool'
alias gdc='git diff --color'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfr='git fetch;git rebase;'
alias gg='git status'
alias gm='git merge'
alias go='git checkout'
alias gr='git rebase'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gg='git lg'
alias gs='git status'
alias gsfrs='git stash;git fetch;git rebase;git stash pop;'
alias gsp='git stash pop'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'

function gdv()
{
    if [[ -n "$1" ]] ; then
        git diff "$*"|gvim -R -
    else
        git diff|gvim -R -
    fi
}

function deleteNewFiles()
{
    git status --short|grep '^??'|awk '{print $2}'|xargs rm -rf
}

function editConfilicts()
{
    vim $(git status --short|grep ^UU|awk '{print $2}')
}

function showConfilictsInRevesion()
{
    if [[ -n "$1" ]] ; then
        echo "will show $*"
    else
        echo "you must specify a revision."
        kill -INT $$
    fi
    git status --short|grep ^UU|awk '{print $2}'|while read -r file;
    do
        echo "file:$file in $*"
        git show "$*:$file"
    done
}

function showModifiedFilesInRevesion()
{
    if [[ -n "$1" ]] ; then
        echo "will show $*"
    else
        echo "you must specify a revision."
        kill -INT $$
    fi
    git status --short|grep '^ M'|awk '{print $2}'|while read -r file;
    do
        echo "file:$file in $*"
        git show "$*:$file"
    done
}
