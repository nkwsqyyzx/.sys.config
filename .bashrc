export SHELL_TYPE=bash
source ~/.sys.config/common.sh

alias l='ls -al'
export PS1='\[\033[01;32m\]\u@$(hostname) \[\033[01;34m\] $(pwd|sed "s#$HOME#~#") \$\[\033[00m\] '
