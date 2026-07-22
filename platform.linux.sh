# Linuxbrew (canonical env setup: PATH + INFOPATH etc.)
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

alias o="nautilus"
alias ou="xdg-open"
alias ll="ls -al --color=auto"
alias ip="ifconfig|sed -n -e '/127.0.0.1/d' -e '/inet /p'|awk -F: '{print \$2}'|awk '{print \$1}'"
alias ifconfig="/sbin/ifconfig"
