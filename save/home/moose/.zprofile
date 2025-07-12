export SCRIPT_HOME="$HOME/.local/scripts"

export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR="nvim"
export BROWSER="qutebrowser"
export TERM="st"
export TERMINAL="st"

export CARGO_HOME="$HOME/.local/cargo"
export OLLAMA_ROCM_ENABLED=1

[[ -z $TMUX ]] && startx
