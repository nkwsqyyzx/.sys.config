export SHELL_TYPE=zsh
plugins=(web-search bundler rake)

ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle ':completion:*:*' ignored-patterns '*ORIG_HEAD'
zstyle ':completion:*:*' ignored-patterns 'origin/HEAD'

compinit -u
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000000
# End of lines configured by zsh-newuser-install
#

rm -rf .zcompdump*

source ~/.sys.config/common.sh
source ~/.sys.config/dirmark/zsh.sh

# 远程登录时，显示特别的提示符
function is_remote() {
    if [[ -n "$SSH_CONNECTION" ]]; then
        echo "🌞🐷 "
    fi
}

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg_bold[red]%}"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(is_remote)$(git_prompt_info)'
