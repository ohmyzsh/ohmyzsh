# Configuration variables
# Automatically start tmux
[[ -n "$ZSH_TMUX_AUTOSTART" ]] || ZSH_TMUX_AUTOSTART = false
# Automatically connect to a previous session if it exists
[[ -n "$ZSH_TMUX_AUTOCONNECT" ]] || ZSH_TMUX_AUTOCONNECT = true
# Automatically close the terminal when tmux exits
[[ -n "$ZSH_TMUX_AUTOQUIT" ]] || ZSH_TMUX_AUTOQUIT = true
# Set term to screen or screen-256color based on current terminal support
[[ -n "$ZSH_TMUX_FIXTERM" ]] || ZSH_TMUX_AUTOCONNECT = true

# Get the absolute path to the current directory
local zsh_tmux_plugin_path="$(cd "$(dirname "$0")" && pwd)"
