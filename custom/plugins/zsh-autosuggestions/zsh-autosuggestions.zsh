# Fish-like fast/unobtrusive autosuggestions for zsh.
# https://github.com/zsh-users/zsh-autosuggestions
# v0.5.2
# Copyright (c) 2013 Thiago de Arruda
# Copyright (c) 2016-2018 Eric Freese
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

#--------------------------------------------------------------------#
# Setup                                                              #
#--------------------------------------------------------------------#

# Precmd hooks for initializing the library and starting pty's
autoload -Uz add-zsh-hook

# Asynchronous suggestions are generated in a pty
zmodload zsh/zpty

#--------------------------------------------------------------------#
# Global Configuration Variables                                     #
#--------------------------------------------------------------------#

# Color to use when highlighting suggestion
# Uses format of `region_highlight`
# More info: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Widgets
(( ! ${+ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE} )) &&
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Prefix to use when saving original versions of bound widgets
(( ! ${+ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX} )) &&
typeset -g ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX=autosuggest-orig-

# Strategies to use to fetch a suggestion
# Will try each strategy in order until a suggestion is returned
(( ! ${+ZSH_AUTOSUGGEST_STRATEGY} )) && {
	typeset -ga ZSH_AUTOSUGGEST_STRATEGY
	ZSH_AUTOSUGGEST_STRATEGY=(history)
}

# Widgets that clear the suggestion
(( ! ${+ZSH_AUTOSUGGEST_CLEAR_WIDGETS} )) && {
	typeset -ga ZSH_AUTOSUGGEST_CLEAR_WIDGETS
	ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
		history-search-forward
		history-search-backward
		history-beginning-search-forward
		history-beginning-search-backward
		history-substring-search-up
		history-substring-search-down
		up-line-or-beginning-search
		down-line-or-beginning-search
		up-line-or-history
		down-line-or-history
		accept-line
	)
}

# Widgets that accept the entire suggestion
(( ! ${+ZSH_AUTOSUGGEST_ACCEPT_WIDGETS} )) && {
	typeset -ga ZSH_AUTOSUGGEST_ACCEPT_WIDGETS
	ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
		forward-char
		end-of-line
		vi-forward-char
		vi-end-of-line
		vi-add-eol
	)
}

# Widgets that accept the entire suggestion and execute it
(( ! ${+ZSH_AUTOSUGGEST_EXECUTE_WIDGETS} )) && {
	typeset -ga ZSH_AUTOSUGGEST_EXECUTE_WIDGETS
	ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=(
	)
}

# Widgets that accept the suggestion as far as the cursor moves
(( ! ${+ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS} )) && {
	typeset -ga ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS
	ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
		forward-word
		emacs-forward-word
		vi-forward-word
		vi-forward-word-end
		vi-forward-blank-word
		vi-forward-blank-word-end
		vi-find-next-char
		vi-find-next-char-skip
	)
}

# Widgets that should be ignored (globbing supported but must be escaped)
(( ! ${+ZSH_AUTOSUGGEST_IGNORE_WIDGETS} )) && {
	typeset -ga ZSH_AUTOSUGGEST_IGNORE_WIDGETS
	ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(
		orig-\*
		beep
		run-help
		set-local-history
		which-command
		yank
		yank-pop
	)
}

#--------------------------------------------------------------------#
# Utility Functions                                                  #
#--------------------------------------------------------------------#

_zsh_autosuggest_escape_command() {
	setopt localoptions EXTENDED_GLOB

	# Escape special chars in the string (requires EXTENDED_GLOB)
	echo -E "${1//(#m)[\"\'\\()\[\]|*?~]/\\$MATCH}"
}

#--------------------------------------------------------------------#
# Widget Helpers                                                     #
#--------------------------------------------------------------------#

_zsh_autosuggest_incr_bind_count() {
	typeset -gi bind_count=$((_ZSH_AUTOSUGGEST_BIND_COUNTS[$1]+1))
	_ZSH_AUTOSUGGEST_BIND_COUNTS[$1]=$bind_count
}

# Bind a single widget to an autosuggest widget, saving a reference to the original widget
_zsh_autosuggest_bind_widget() {
	typeset -gA _ZSH_AUTOSUGGEST_BIND_COUNTS

	local widget=$1
	local autosuggest_action=$2
	local prefix=$ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX

	local -i bind_count

	# Save a reference to the original widget
	case $widgets[$widget] in
		# Already bound
		user:_zsh_autosuggest_(bound|orig)_*)
			bind_count=$((_ZSH_AUTOSUGGEST_BIND_COUNTS[$widget]))
			;;

		# User-defined widget
		user:*)
			_zsh_autosuggest_incr_bind_count $widget
			zle -N $prefix$bind_count-$widget ${widgets[$widget]#*:}
			;;

		# Built-in widget
		builtin)
			_zsh_autosuggest_incr_bind_count $widget
			eval "_zsh_autosuggest_orig_${(q)widget}() { zle .${(q)widget} }"
			zle -N $prefix$bind_count-$widget _zsh_autosuggest_orig_$widget
			;;

		# Completion widget
		completion:*)
			_zsh_autosuggest_incr_bind_count $widget
			eval "zle -C $prefix$bind_count-${(q)widget} ${${(s.:.)widgets[$widget]}[2,3]}"
			;;
	esac

	# Pass the original widget's name explicitly into the autosuggest
	# function. Use this passed in widget name to call the original
	# widget instead of relying on the $WIDGET variable being set
	# correctly. $WIDGET cannot be trusted because other plugins call
	# zle without the `-w` flag (e.g. `zle self-insert` instead of
	# `zle self-insert -w`).
	eval "_zsh_autosuggest_bound_${bind_count}_${(q)widget}() {
		_zsh_autosuggest_widget_$autosuggest_action $prefix$bind_count-${(q)widget} \$@
	}"

	# Create the bound widget
	zle -N -- $widget _zsh_autosuggest_bound_${bind_count}_$widget
}

# Map all configured widgets to the right autosuggest widgets
_zsh_autosuggest_bind_widgets() {
	emulate -L zsh

 	local widget
	local ignore_widgets

	ignore_widgets=(
		.\*
		_\*
		zle-\*
		autosuggest-\*
		$ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX\*
		$ZSH_AUTOSUGGEST_IGNORE_WIDGETS
	)

	# Find every widget we might want to bind and bind it appropriately
	for widget in ${${(f)"$(builtin zle -la)"}:#${(j:|:)~ignore_widgets}}; do
		if [[ -n ${ZSH_AUTOSUGGEST_CLEAR_WIDGETS[(r)$widget]} ]]; then
			_zsh_autosuggest_bind_widget $widget clear
		elif [[ -n ${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[(r)$widget]} ]]; then
			_zsh_autosuggest_bind_widget $widget accept
		elif [[ -n ${ZSH_AUTOSUGGEST_EXECUTE_WIDGETS[(r)$widget]} ]]; then
			_zsh_autosuggest_bind_widget $widget execute
		elif [[ -n ${ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS[(r)$widget]} ]]; then
			_zsh_autosuggest_bind_widget $widget partial_accept
		else
			# Assume any unspecified widget might modify the buffer
			_zsh_autosuggest_bind_widget $widget modify
		fi
	done
}

# Given the name of an original widget and args, invoke it, if it exists
_zsh_autosuggest_invoke_original_widget() {
	# Do nothing unless called with at least one arg
	(( $# )) || return 0

	local original_widget_name="$1"

	shift

	if (( ${+widgets[$original_widget_name]} )); then
		zle $original_widget_name -- $@
	fi
}

#--------------------------------------------------------------------#
# Highlighting                                                       #
#--------------------------------------------------------------------#

# If there was a highlight, remove it
_zsh_autosuggest_highlight_reset() {
	typeset -g _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT

	if [[ -n "$_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT" ]]; then
		region_highlight=("${(@)region_highlight:#$_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT}")
		unset _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT
	fi
}

# If there's a suggestion, highlight it
_zsh_autosuggest_highlight_apply() {
	typeset -g _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT

	if (( $#POSTDISPLAY )); then
		typeset -g _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT="$#BUFFER $(($#BUFFER + $#POSTDISPLAY)) $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE"
		region_highlight+=("$_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT")
	else
		unset _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT
	fi
}

#--------------------------------------------------------------------#
# Autosuggest Widget Implementations                                 #
#--------------------------------------------------------------------#

# Disable suggestions
_zsh_autosuggest_disable() {
	typeset -g _ZSH_AUTOSUGGEST_DISABLED
	_zsh_autosuggest_clear
}

# Enable suggestions
_zsh_autosuggest_enable() {
	unset _ZSH_AUTOSUGGEST_DISABLED

	if (( $#BUFFER )); then
		_zsh_autosuggest_fetch
	fi
}

# Toggle suggestions (enable/disable)
_zsh_autosuggest_toggle() {
	if [[ -n "${_ZSH_AUTOSUGGEST_DISABLED+x}" ]]; then
		_zsh_autosuggest_enable
	else
		_zsh_autosuggest_disable
	fi
}

# Clear the suggestion
_zsh_autosuggest_clear() {
	# Remove the suggestion
	unset POSTDISPLAY

	_zsh_autosuggest_invoke_original_widget $@
}

# Modify the buffer and get a new suggestion
_zsh_autosuggest_modify() {
	local -i retval

	# Only available in zsh >= 5.4
	local -i KEYS_QUEUED_COUNT

	# Save the contents of the buffer/postdisplay
	local orig_buffer="$BUFFER"
	local orig_postdisplay="$POSTDISPLAY"

	# Clear suggestion while waiting for next one
	unset POSTDISPLAY

	# Original widget may modify the buffer
	_zsh_autosuggest_invoke_original_widget $@
	retval=$?

	emulate -L zsh

	# Don't fetch a new suggestion if there's more input to be read immediately
	if (( $PENDING > 0 )) || (( $KEYS_QUEUED_COUNT > 0 )); then
		POSTDISPLAY="$orig_postdisplay"
		return $retval
	fi

	# Optimize if manually typing in the suggestion
	if (( $#BUFFER > $#orig_buffer )); then
		local added=${BUFFER#$orig_buffer}

		# If the string added matches the beginning of the postdisplay
		if [[ "$added" = "${orig_postdisplay:0:$#added}" ]]; then
			POSTDISPLAY="${orig_postdisplay:$#added}"
			return $retval
		fi
	fi

	# Don't fetch a new suggestion if the buffer hasn't changed
	if [[ "$BUFFER" = "$orig_buffer" ]]; then
		POSTDISPLAY="$orig_postdisplay"
		return $retval
	fi

	# Bail out if suggestions are disabled
	if [[ -n "${_ZSH_AUTOSUGGEST_DISABLED+x}" ]]; then
		return $?
	fi

	# Get a new suggestion if the buffer is not empty after modification
	if (( $#BUFFER > 0 )); then
		if (( ! ${+ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE} )) || (( $#BUFFER <= $ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE )); then
			_zsh_autosuggest_fetch
		fi
	fi

	return $retval
}

# Fetch a new suggestion based on what's currently in the buffer
_zsh_autosuggest_fetch() {
	if (( ${+ZSH_AUTOSUGGEST_USE_ASYNC} )); then
		_zsh_autosuggest_async_request "$BUFFER"
	else
		local suggestion
		_zsh_autosuggest_fetch_suggestion "$BUFFER"
		_zsh_autosuggest_suggest "$suggestion"
	fi
}

# Offer a suggestion
_zsh_autosuggest_suggest() {
	emulate -L zsh

	local suggestion="$1"

	if [[ -n "$suggestion" ]] && (( $#BUFFER )); then
		POSTDISPLAY="${suggestion#$BUFFER}"
	else
		unset POSTDISPLAY
	fi
}

# Accept the entire suggestion
_zsh_autosuggest_accept() {
	local -i max_cursor_pos=$#BUFFER

	# When vicmd keymap is active, the cursor can't move all the way
	# to the end of the buffer
	if [[ "$KEYMAP" = "vicmd" ]]; then
		max_cursor_pos=$((max_cursor_pos - 1))
	fi

	# Only accept if the cursor is at the end of the buffer
	if [[ $CURSOR = $max_cursor_pos ]]; then
		# Add the suggestion to the buffer
		BUFFER="$BUFFER$POSTDISPLAY"

		# Remove the suggestion
		unset POSTDISPLAY

		# Move the cursor to the end of the buffer
		CURSOR=${#BUFFER}
	fi

	_zsh_autosuggest_invoke_original_widget $@
}

# Accept the entire suggestion and execute it
_zsh_autosuggest_execute() {
	# Add the suggestion to the buffer
	BUFFER="$BUFFER$POSTDISPLAY"

	# Remove the suggestion
	unset POSTDISPLAY

	# Call the original `accept-line` to handle syntax highlighting or
	# other potential custom behavior
	_zsh_autosuggest_invoke_original_widget "accept-line"
}

# Partially accept the suggestion
_zsh_autosuggest_partial_accept() {
	local -i retval cursor_loc

	# Save the contents of the buffer so we can restore later if needed
	local original_buffer="$BUFFER"

	# Temporarily accept the suggestion.
	BUFFER="$BUFFER$POSTDISPLAY"

	# Original widget moves the cursor
	_zsh_autosuggest_invoke_original_widget $@
	retval=$?

	# Normalize cursor location across vi/emacs modes
	cursor_loc=$CURSOR
	if [[ "$KEYMAP" = "vicmd" ]]; then
		cursor_loc=$((cursor_loc + 1))
	fi

	# If we've moved past the end of the original buffer
	if (( $cursor_loc > $#original_buffer )); then
		# Set POSTDISPLAY to text right of the cursor
		POSTDISPLAY="${BUFFER[$(($cursor_loc + 1)),$#BUFFER]}"

		# Clip the buffer at the cursor
		BUFFER="${BUFFER[1,$cursor_loc]}"
	else
		# Restore the original buffer
		BUFFER="$original_buffer"
	fi

	return $retval
}

() {
	local action
	for action in clear modify fetch suggest accept partial_accept execute enable disable toggle; do
		eval "_zsh_autosuggest_widget_$action() {
			local -i retval

			_zsh_autosuggest_highlight_reset

			_zsh_autosuggest_$action \$@
			retval=\$?

			_zsh_autosuggest_highlight_apply

			zle -R

			return \$retval
		}"
	done

	zle -N autosuggest-fetch _zsh_autosuggest_widget_fetch
	zle -N autosuggest-suggest _zsh_autosuggest_widget_suggest
	zle -N autosuggest-accept _zsh_autosuggest_widget_accept
	zle -N autosuggest-clear _zsh_autosuggest_widget_clear
	zle -N autosuggest-execute _zsh_autosuggest_widget_execute
	zle -N autosuggest-enable _zsh_autosuggest_widget_enable
	zle -N autosuggest-disable _zsh_autosuggest_widget_disable
	zle -N autosuggest-toggle _zsh_autosuggest_widget_toggle
}

#--------------------------------------------------------------------#
# History Suggestion Strategy                                        #
#--------------------------------------------------------------------#
# Suggests the most recent history item that matches the given
# prefix.
#

_zsh_autosuggest_strategy_history() {
	# Reset options to defaults and enable LOCAL_OPTIONS
	emulate -L zsh

	# Enable globbing flags so that we can use (#m)
	setopt EXTENDED_GLOB

	# Escape backslashes and all of the glob operators so we can use
	# this string as a pattern to search the $history associative array.
	# - (#m) globbing flag enables setting references for match data
	# TODO: Use (b) flag when we can drop support for zsh older than v5.0.8
	local prefix="${1//(#m)[\\*?[\]<>()|^~#]/\\$MATCH}"

	# Get the history items that match
	# - (r) subscript flag makes the pattern match on values
	typeset -g suggestion="${history[(r)${prefix}*]}"
}

#--------------------------------------------------------------------#
# Match Previous Command Suggestion Strategy                         #
#--------------------------------------------------------------------#
# Suggests the most recent history item that matches the given
# prefix and whose preceding history item also matches the most
# recently executed command.
#
# For example, suppose your history has the following entries:
#   - pwd
#   - ls foo
#   - ls bar
#   - pwd
#
# Given the history list above, when you type 'ls', the suggestion
# will be 'ls foo' rather than 'ls bar' because your most recently
# executed command (pwd) was previously followed by 'ls foo'.
#
# Note that this strategy won't work as expected with ZSH options that don't
# preserve the history order such as `HIST_IGNORE_ALL_DUPS` or
# `HIST_EXPIRE_DUPS_FIRST`.

_zsh_autosuggest_strategy_match_prev_cmd() {
	# Reset options to defaults and enable LOCAL_OPTIONS
	emulate -L zsh

	# Enable globbing flags so that we can use (#m)
	setopt EXTENDED_GLOB

	# TODO: Use (b) flag when we can drop support for zsh older than v5.0.8
	local prefix="${1//(#m)[\\*?[\]<>()|^~#]/\\$MATCH}"

	# Get all history event numbers that correspond to history
	# entries that match pattern $prefix*
	local history_match_keys
	history_match_keys=(${(k)history[(R)$prefix*]})

	# By default we use the first history number (most recent history entry)
	local histkey="${history_match_keys[1]}"

	# Get the previously executed command
	local prev_cmd="$(_zsh_autosuggest_escape_command "${history[$((HISTCMD-1))]}")"

	# Iterate up to the first 200 history event numbers that match $prefix
	for key in "${(@)history_match_keys[1,200]}"; do
		# Stop if we ran out of history
		[[ $key -gt 1 ]] || break

		# See if the history entry preceding the suggestion matches the
		# previous command, and use it if it does
		if [[ "${history[$((key - 1))]}" == "$prev_cmd" ]]; then
			histkey="$key"
			break
		fi
	done

	# Give back the matched history entry
	typeset -g suggestion="$history[$histkey]"
}

#--------------------------------------------------------------------#
# Fetch Suggestion                                                   #
#--------------------------------------------------------------------#
# Loops through all specified strategies and returns a suggestion
# from the first strategy to provide one.
#

_zsh_autosuggest_fetch_suggestion() {
	typeset -g suggestion
	local -a strategies
	local strategy

	# Ensure we are working with an array
	strategies=(${=ZSH_AUTOSUGGEST_STRATEGY})

	for strategy in $strategies; do
		# Try to get a suggestion from this strategy
		_zsh_autosuggest_strategy_$strategy "$1"

		# Break once we've found a suggestion
		[[ -n "$suggestion" ]] && break
	done
}

#--------------------------------------------------------------------#
# Async                                                              #
#--------------------------------------------------------------------#

zmodload zsh/system

_zsh_autosuggest_async_request() {
	typeset -g _ZSH_AUTOSUGGEST_ASYNC_FD _ZSH_AUTOSUGGEST_CHILD_PID

	# If we've got a pending request, cancel it
	if [[ -n "$_ZSH_AUTOSUGGEST_ASYNC_FD" ]] && { true <&$_ZSH_AUTOSUGGEST_ASYNC_FD } 2>/dev/null; then
		# Close the file descriptor and remove the handler
		exec {_ZSH_AUTOSUGGEST_ASYNC_FD}<&-
		zle -F $_ZSH_AUTOSUGGEST_ASYNC_FD

		# Zsh will make a new process group for the child process only if job
		# control is enabled (MONITOR option)
		if [[ -o MONITOR ]]; then
			# Send the signal to the process group to kill any processes that may
			# have been forked by the suggestion strategy
			kill -TERM -$_ZSH_AUTOSUGGEST_CHILD_PID 2>/dev/null
		else
			# Kill just the child process since it wasn't placed in a new process
			# group. If the suggestion strategy forked any child processes they may
			# be orphaned and left behind.
			kill -TERM $_ZSH_AUTOSUGGEST_CHILD_PID 2>/dev/null
		fi
	fi

	# Fork a process to fetch a suggestion and open a pipe to read from it
	exec {_ZSH_AUTOSUGGEST_ASYNC_FD}< <(
		# Tell parent process our pid
		echo $sysparams[pid]

		# Fetch and print the suggestion
		local suggestion
		_zsh_autosuggest_fetch_suggestion "$1"
		echo -nE "$suggestion"
	)

	# There's a weird bug here where ^C stops working unless we force a fork
	# See https://github.com/zsh-users/zsh-autosuggestions/issues/364
	command true

	# Read the pid from the child process
	read _ZSH_AUTOSUGGEST_CHILD_PID <&$_ZSH_AUTOSUGGEST_ASYNC_FD

	# When the fd is readable, call the response handler
	zle -F "$_ZSH_AUTOSUGGEST_ASYNC_FD" _zsh_autosuggest_async_response
}

# Called when new data is ready to be read from the pipe
# First arg will be fd ready for reading
# Second arg will be passed in case of error
_zsh_autosuggest_async_response() {
	emulate -L zsh

	if [[ -z "$2" || "$2" == "hup" ]]; then
		# Read everything from the fd and give it as a suggestion
		zle autosuggest-suggest -- "$(cat <&$1)"

		# Close the fd
		exec {1}<&-
	fi

	# Always remove the handler
	zle -F "$1"
}

#--------------------------------------------------------------------#
# Start                                                              #
#--------------------------------------------------------------------#

# Start the autosuggestion widgets
_zsh_autosuggest_start() {
	# By default we re-bind widgets on every precmd to ensure we wrap other
	# wrappers. Specifically, highlighting breaks if our widgets are wrapped by
	# zsh-syntax-highlighting widgets. This also allows modifications to the
	# widget list variables to take effect on the next precmd. However this has
	# a decent performance hit, so users can set ZSH_AUTOSUGGEST_MANUAL_REBIND
	# to disable the automatic re-binding.
	if (( ${+ZSH_AUTOSUGGEST_MANUAL_REBIND} )); then
		add-zsh-hook -d precmd _zsh_autosuggest_start
	fi

	_zsh_autosuggest_bind_widgets
}

# Start the autosuggestion widgets on the next precmd
add-zsh-hook precmd _zsh_autosuggest_start
