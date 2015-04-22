alias o='open'
alias ou='open'
alias ll='ls -alG'
alias ip="ifconfig | sed -n -e '/127.0.0.1/d' -e '/inet /p'|awk '{print \$2}'"

export DIFFMERGE_EXE=/Applications/DiffMerge.app/Contents/MacOS/DiffMerge
