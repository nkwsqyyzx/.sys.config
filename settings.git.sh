# good experience with git.
alias ga='git add'
alias gai='git add -i'
alias gap='git add -p'
alias gb='git branch'
alias gc='git commit'
alias gca='git commit -a'
alias gd='git diff'
alias gdc='git diff --color'
alias gdd='git difftool'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfr='git fetch;git rebase;'
alias gg='git status'
alias gm='git merge'
alias go='git checkout'
alias gr='git rebase'
alias gs='git status'
alias gsfrs='git stash;git fetch;git rebase;git stash pop;'
alias gsp='git stash pop'

function gdv()
{
    if [[ -n "$1" ]] ; then
        git diff "$*"|gvim -R -
    else
        git diff|gvim -R -
    fi
}
