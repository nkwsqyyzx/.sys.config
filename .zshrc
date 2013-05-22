export PATH=$PATH:/usr/local/bin:/usr/bin:/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/Wbem:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0:/cygdrive/c/Program\ Files/Git/cmd:/usr/bin:/cygdrive/c/Program\ Files/Microsoft/Web\ Platform\ Installer:/cygdrive/c/Program\ Files/Microsoft\ ASP.NET/ASP.NET\ Web\ Pages/v1.0:/cygdrive/c/Program\ Files/Windows\ Kits/8.0/Windows\ Performance\ Toolkit:/cygdrive/c/Program\ Files/Microsoft\ SQL\ Server/110/Tools/Binn:/cygdrive/c/Program\ Files/TortoiseSVN/bin

ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugin=(git)

source $ZSH/oh-my-zsh.sh

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000000
# End of lines configured by zsh-newuser-install
#

source ~/.bashrc
