# this file contains normal alias, used by all platform
# platform related alias should place in related file

alias la='ls -al'

# good experience with cd.
alias .='cd -'
alias ..='cd ..'
alias ...='cd ../..'

# o is alias to open in mingw/cygstart in cygwin/nautilus in ubuntu
alias op='o ..'
alias oo='o .'

# alias to open favorite sites.
# ou is alias to open url.
alias ogoogle='ou https://www.google.com'
alias oengoogle='ou https://www.google.com/ncr'
alias oweibo='ou http://weibo.com'

# disable this line if you still use emacs!
alias emacs=vim

# better less
alias L='less -R'

# fzf
alias glpdir='fzf --bind "enter:execute(git log -p {})"'
alias gvimdir='fzf --bind "enter:execute(gvim --remote-tab-silent {})"'

alias df='df -h'

alias lc='cl'

alias tail='tail -F --retry'
