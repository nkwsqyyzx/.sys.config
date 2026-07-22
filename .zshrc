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

function remote_name() {
    if [[ -n "$SSH_CONNECTION" ]]; then
        echo "%{$fg[blue]%}$(uname -n)%{$reset_color%} "
    fi
}

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg_bold[red]%}"
PROMPT='${ret_status} $(remote_name)%{$fg[cyan]%}%c%{$reset_color%} $(is_remote)$(git_prompt_info)'

# # 创建一个内存级的文件夹
# if [[ ! -e /tmp/1/memory ]]; then
#     mkdir -p /tmp/1
#     if [[ -d /dev/shm ]]; then
#         mkdir -p /dev/shm/memory
#         (cd /tmp/1; ln -s /Volumes/RAMDisk memory)
#     fi
# 
#     if [[ "$ENABLE_MEMORY_DISK_OSX" == '1' ]] && [[ "${SYS_OS}" == 'mac' ]]; then
#         if [[ ! -d /Volumes/RAMDisk/ ]]; then
#             # 创建一个2G的内存硬盘
#             diskutil erasevolume HFS+ "RAMDisk" `hdiutil attach -nomount ram://4194304`
#             mkdir -p /Volumes/RAMDisk/root
#         fi
#         (cd /tmp/1; ln -s /Volumes/RAMDisk/root memory)
#     fi
# fi

# pnpm
export PNPM_HOME="/Users/nahco3/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
export PYTHONPATH=.

# ~/bin 优先 (覆盖系统 cc → claude --dangerously-skip-permissions)
export PATH="$HOME/bin:$PATH"

# claude shell alias (跳过权限)
alias claude='/usr/local/bin/claude --dangerously-skip-permissions'

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"

# OpenClaw Completion
[ -f "/Users/nahco3/.openclaw/completions/openclaw.zsh" ] && source "/Users/nahco3/.openclaw/completions/openclaw.zsh"
