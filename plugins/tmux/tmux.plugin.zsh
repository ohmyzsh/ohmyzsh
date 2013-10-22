#
# Aliases
#

alias ta='tmux attach -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'

# Only run if tmux is actually installed
if which tmux &> /dev/null
	then
	# Configuration variables
	#
	# Automatically start tmux
	[[ -n "$ZSH_TMUX_AUTOSTART" ]] || ZSH_TMUX_AUTOSTART=false
	# Only autostart once. If set to false, tmux will attempt to
	# autostart every time your zsh configs are reloaded.
	[[ -n "$ZSH_TMUX_AUTOSTART_ONCE" ]] || ZSH_TMUX_AUTOSTART_ONCE=true
	# Automatically connect to a previous session if it exists
	[[ -n "$ZSH_TMUX_AUTOCONNECT" ]] || ZSH_TMUX_AUTOCONNECT=true
	# Automatically close the terminal when tmux exits
	[[ -n "$ZSH_TMUX_AUTOQUIT" ]] || ZSH_TMUX_AUTOQUIT=$ZSH_TMUX_AUTOSTART
	# Set term to screen or screen-256color based on current terminal support
	[[ -n "$ZSH_TMUX_FIXTERM" ]] || ZSH_TMUX_FIXTERM=true
	# Group with the previous session instead of attaching to it
	[[ -n "$ZSH_TMUX_GROUP" ]] || ZSH_TMUX_GROUP=false
	# Set '-CC' option for iTerm2 tmux integration
	[[ -n "$ZSH_TMUX_ITERM2" ]] || ZSH_TMUX_ITERM2=false
	# The TERM to use for non-256 color terminals.
	# Tmux states this should be screen, but you may need to change it on
	# systems without the proper terminfo
	[[ -n "$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR" ]] || ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="screen"
	# The TERM to use for 256 color terminals.
	# Tmux states this should be screen-256color, but you may need to change it on
	# systems without the proper terminfo
	[[ -n "$ZSH_TMUX_FIXTERM_WITH_256COLOR" ]] || ZSH_TMUX_FIXTERM_WITH_256COLOR="screen-256color"


	# Get the absolute path to the current directory
	local zsh_tmux_plugin_path="$(cd "$(dirname "$0")" && pwd)"

	# Determine if the terminal supports 256 colors
	if [[ `tput colors` == "256" ]]
	then
		export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITH_256COLOR
	else
		export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR
	fi

	# Set the correct local config file to use.
    if [[ "$ZSH_TMUX_ITERM2" == "false" ]] && [[ -f $HOME/.tmux.conf || -h $HOME/.tmux.conf ]]
	then
		#use this when they have a ~/.tmux.conf
		export _ZSH_TMUX_FIXED_CONFIG="$zsh_tmux_plugin_path/tmux.extra.conf"
	else
		#use this when they don't have a ~/.tmux.conf
		export _ZSH_TMUX_FIXED_CONFIG="$zsh_tmux_plugin_path/tmux.only.conf"
	fi

	# Wrapper function for tmux.
	function _zsh_tmux_plugin_run()
	{
		# Construct options.
		[[ "$ZSH_TMUX_ITERM2"  == "true" ]] && tmux_options+=("-CC")
		[[ "$ZSH_TMUX_FIXTERM" == "true" ]] && tmux_options+=("-f" "$_ZSH_TMUX_FIXED_CONFIG")

		# We have other arguments, just run them
		if [[ -n "$@" ]]
		then
			\tmux $@
		# Try to connect to an existing session.
		elif [[ "$ZSH_TMUX_AUTOCONNECT" == "true" ]]
		then
			# Group with an existing session or create a new one.
			if [[ "$ZSH_TMUX_GROUP" == "true" ]]; then
				sessions="$(tmux list-sessions -F '#{session_grouped} #{session_attached} #{session_name}')"
				grouped_sessions="$(echo "$sessions" | grep '^1')"

				# Join an existing group.
				if [[ -n "$grouped_sessions" ]]; then
					unattached_session="$(echo "$grouped_sessions" | awk '$2 == 0 {print $3; exit}')"

					# Reuse an unattached, grouped session or create a new one.
					if [[ -n "$unattached_session" ]]; then
						\tmux $tmux_options attach-session -t "$unattached_session"
					else
						\tmux $tmux_options new-session -t "$unattached_session"
					fi
				# There are no existing groups.
				else
					first_session="$(echo "$sessions" | awk '{print $3; exit}')"

					# Create a new session, grouped if there is anything to group with.
					if [[ -n "$first_session" ]]; then
						\tmux $tmux_options new-session -t "$first_session"
					else
						\tmux $tmux_options new-session
					fi
				fi
			# Attach to an existing session or create a new one.
			else
				\tmux $tmux_options attach || \tmux $tmux_options new-session
			fi

			[[ "$ZSH_TMUX_AUTOQUIT" == "true" ]] && exit
		# Just run tmux, fixing the TERM variable if requested.
		else
			\tmux $tmux_options
			[[ "$ZSH_TMUX_AUTOQUIT" == "true" ]] && exit
		fi
	}

	# Use the completions for tmux for our function
	compdef _tmux _zsh_tmux_plugin_run

	# Alias tmux to our wrapper function.
	alias tmux=_zsh_tmux_plugin_run

	# Autostart if not already in tmux and enabled.
	if [[ ! -n "$TMUX" && "$ZSH_TMUX_AUTOSTART" == "true" ]]
	then
		# Actually don't autostart if we already did and multiple autostarts are disabled.
		if [[ "$ZSH_TMUX_AUTOSTART_ONCE" == "false" || "$ZSH_TMUX_AUTOSTARTED" != "true" ]]
		then
			export ZSH_TMUX_AUTOSTARTED=true
			_zsh_tmux_plugin_run
		fi
	fi
else
	print "zsh tmux plugin: tmux not found. Please install tmux before using this plugin."
fi
