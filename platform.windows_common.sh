export LESSCHARSET=utf-8

# windows common alias for
alias kfirefox='taskkill /f /pid $(tasklist|grep ^firefox|awk "{print \$2}")'
source ~/.sys.config/ConfigureVim.sh
