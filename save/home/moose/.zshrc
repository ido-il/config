export ZSH="$HOME/.config/oh-my-zsh"
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"

alias nv="nvim"
alias gs="git status"

ZSH_THEME="nicoulaj"
plugins=(git)

source $ZSH/oh-my-zsh.sh
