# Linuxbrew shellenv 已在 common.sh 早加载 (cd.sh 检查 autojump/fzf 之前)
# 这里只保留 aliases

alias o="nautilus"
alias ou="xdg-open"
alias ll="ls -al --color=auto"
alias ip="ifconfig|sed -n -e '/127.0.0.1/d' -e '/inet /p'|awk -F: '{print \$2}'|awk '{print \$1}'"
alias ifconfig="/sbin/ifconfig"
