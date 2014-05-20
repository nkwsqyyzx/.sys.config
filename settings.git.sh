# good experience with git.
alias gs='git status'
alias gg='git status'
alias gc='git commit'
alias gca='git commit -a'
alias ga='git add'
alias gai='git add -i'
alias gap='git add -p'
alias gsp='git stash pop'
alias go='git checkout'
alias gb='git branch'
alias gm='git merge'
alias gd='git diff'
alias gds='git diff --staged'
alias gdc='git diff --color'
alias gdd='git difftool'

function gdv()
{
    if [[ -n "$1" ]] ; then
        git diff "$*"|gvim -R -
    else
        git diff|gvim -R -
    fi
}
