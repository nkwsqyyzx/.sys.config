# good experience with svn.
export SVN_EDITOR=vim
alias up='svn up'
alias st='svn st'
alias sd='svn diff'
alias svnremovedeletedfiles="svn st|grep '^!'|sed 's/^! *//'|xargs -I% svn rm %"
alias svnadduntrackedfiles="svn st|awk '/^?/ {print \$2}'|sed 's/\\\\/\\//g'|xargs svn add --force"
alias svnremoveaddedfiles="svn st|awk '/^A/ {print \$2}'|sed 's/\\\\/\\//g'|xargs svn remove --keep-local --force"
