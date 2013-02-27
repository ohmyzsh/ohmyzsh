# Configuration variables
# Automatically start tmux
[[ -n "$ZSH_TMUX_AUTOSTART" ]] || ZSH_TMUX_AUTOSTART=false
# Automatically connect to a previous session if it exists
[[ -n "$ZSH_TMUX_AUTOCONNECT" ]] || ZSH_TMUX_AUTOCONNECT=true
# Automatically close the terminal when tmux exits
[[ -n "$ZSH_TMUX_AUTOQUIT" ]] || ZSH_TMUX_AUTOQUIT=$ZSH_TMUX_AUTOSTART
# Set term to screen or screen-256color based on current terminal support
[[ -n "$ZSH_TMUX_FIXTERM" ]] || ZSH_TMUX_FIXTERM=true

# Get the absolute path to the current directory
local zsh_tmux_plugin_path="$(cd "$(dirname "$0")" && pwd)"

# Determine if the terminal supports 256 colors
if [[ `tput colors` == "256" ]]
then
	export ZSH_TMUX_TERM="screen-256color"
else
	export ZSH_TMUX_TERM="screen"
fi

# Local variable to store the local config file to use, if any.
local fixed_config=""

# Set the correct local config file to use.
if [[ -f $HOME/.tmux.conf || -h $HOME/.tmux.conf ]]
then
	#use this when they have a ~/.tmux.conf
	fixed_config="$zsh_tmux_plugin_path/tmux.extra.conf"
else
	#use this when they don't have a ~/.tmux.conf
	fixed_config="$zsh_tmux_plugin_path/tmux.only.conf"
fi

# Wrapper function for tmux.
function zsh_tmux_plugin_run()
{
	# We have other arguments, just run them
	if [[ -n "$@" ]]
	then
		\tmux $@
	# Try to connect to an existing session.
	elif [[ "$ZSH_TMUX_AUTOCONNECT" == "true" ]]
	then
		\tmux attach || \tmux `[[ "$ZSH_TMUX_FIXTERM" == "true" ]] && echo '-f '$fixed_config`  new-session
		[[ "$ZSH_TMUX_AUTOQUIT" == "true" ]] && exit
	# Just run tmux, fixing the TERM variable if requested.
	else
		\tmux `[[ "$ZSH_TMUX_FIXTERM" == "true" ]] && echo '-f '$fixed_config`
		[[ "$ZSH_TMUX_AUTOQUIT" == "true" ]] && exit
	fi
}

# Alias tmux to our wrapper function.
alias tmux=zsh_tmux_plugin_start

if [[ "$ZSH_TMUX_AUTOSTART" == "true" ]]
then
	zsh_tmux_plugin_run
fi
