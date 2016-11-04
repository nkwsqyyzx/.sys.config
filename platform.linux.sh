alias o='nautilus'
alias ou='xdg-open'
alias ll='ls -al --color=auto'
alias ip="ifconfig|sed -n -e '/127.0.0.1/d' -e '/inet /p'|awk -F: '{print \$2}'|awk '{print \$1}'"
alias ifconfig='/sbin/ifconfig'
