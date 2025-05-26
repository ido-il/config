export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR="nvim"
export BROWSER="qutebrowser"
export TERM="st"
export TERMINAL="st"

[[ -z $TMUX ]] && startx
