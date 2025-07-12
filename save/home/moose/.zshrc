alias nv="nvim"
alias gc="git commit"
alias ga="git add"
alias gs="git status"

[[ -d $CARGO_HOME ]] && source $CARGO_HOME/env

# oh-my-zsh
export ZSH="$HOME/.config/oh-my-zsh"

ZSH_THEME="nicoulaj"
plugins=(git)

source $ZSH/oh-my-zsh.sh
