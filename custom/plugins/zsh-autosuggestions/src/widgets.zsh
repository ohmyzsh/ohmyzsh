
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
