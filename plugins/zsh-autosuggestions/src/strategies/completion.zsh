
#--------------------------------------------------------------------#
# Completion Suggestion Strategy                                     #
#--------------------------------------------------------------------#
# Fetches a suggestion from the completion engine
#

_zsh_autosuggest_capture_postcompletion() {
	# Always insert the first completion into the buffer
	compstate[insert]=1

	# Don't list completions
	unset 'compstate[list]'
}

_zsh_autosuggest_capture_completion_widget() {
	# Add a post-completion hook to be called after all completions have been
	# gathered. The hook can modify compstate to affect what is done with the
	# gathered completions.
	local -a +h comppostfuncs
	comppostfuncs=(_zsh_autosuggest_capture_postcompletion)

	# Only capture completions at the end of the buffer
	CURSOR=$#BUFFER

	# Run the original widget wrapping `.complete-word` so we don't
	# recursively try to fetch suggestions, since our pty is forked
	# after autosuggestions is initialized.
	zle -- ${(k)widgets[(r)completion:.complete-word:_main_complete]}

	if is-at-least 5.0.3; then
		# Don't do any cr/lf transformations. We need to do this immediately before
		# output because if we do it in setup, onlcr will be re-enabled when we enter
		# vared in the async code path. There is a bug in zpty module in older versions
		# where the tty is not properly attached to the pty slave, resulting in stty
		# getting stopped with a SIGTTOU. See zsh-workers thread 31660 and upstream
		# commit f75904a38
		stty -onlcr -ocrnl -F /dev/tty
	fi

	# The completion has been added, print the buffer as the suggestion
	echo -nE - $'\0'$BUFFER$'\0'
}

zle -N autosuggest-capture-completion _zsh_autosuggest_capture_completion_widget

_zsh_autosuggest_capture_setup() {
	# There is a bug in zpty module in older zsh versions by which a
	# zpty that exits will kill all zpty processes that were forked
	# before it. Here we set up a zsh exit hook to SIGKILL the zpty
	# process immediately, before it has a chance to kill any other
	# zpty processes.
	if ! is-at-least 5.4; then
		zshexit() {
			# The zsh builtin `kill` fails sometimes in older versions
			# https://unix.stackexchange.com/a/477647/156673
			kill -KILL $$ 2>&- || command kill -KILL $$

			# Block for long enough for the signal to come through
			sleep 1
		}
	fi

	# Try to avoid any suggestions that wouldn't match the prefix
	zstyle ':completion:*' matcher-list ''
	zstyle ':completion:*' path-completion false
	zstyle ':completion:*' max-errors 0 not-numeric

	bindkey '^I' autosuggest-capture-completion
}

_zsh_autosuggest_capture_completion_sync() {
	_zsh_autosuggest_capture_setup

	zle autosuggest-capture-completion
}

_zsh_autosuggest_capture_completion_async() {
	_zsh_autosuggest_capture_setup

	zmodload zsh/parameter 2>/dev/null || return # For `$functions`

	# Make vared completion work as if for a normal command line
	# https://stackoverflow.com/a/7057118/154703
	autoload +X _complete
	functions[_original_complete]=$functions[_complete]
	function _complete() {
		unset 'compstate[vared]'
		_original_complete "$@"
	}

	# Open zle with buffer set so we can capture completions for it
	vared 1
}

_zsh_autosuggest_strategy_completion() {
	# Reset options to defaults and enable LOCAL_OPTIONS
	emulate -L zsh

	# Enable extended glob for completion ignore pattern
	setopt EXTENDED_GLOB

	typeset -g suggestion
	local line REPLY

	# Exit if we don't have completions
	whence compdef >/dev/null || return

	# Exit if we don't have zpty
	zmodload zsh/zpty 2>/dev/null || return

	# Exit if our search string matches the ignore pattern
	[[ -n "$ZSH_AUTOSUGGEST_COMPLETION_IGNORE" ]] && [[ "$1" == $~ZSH_AUTOSUGGEST_COMPLETION_IGNORE ]] && return

	# Zle will be inactive if we are in async mode
	if zle; then
		zpty $ZSH_AUTOSUGGEST_COMPLETIONS_PTY_NAME _zsh_autosuggest_capture_completion_sync
	else
		zpty $ZSH_AUTOSUGGEST_COMPLETIONS_PTY_NAME _zsh_autosuggest_capture_completion_async "\$1"
		zpty -w $ZSH_AUTOSUGGEST_COMPLETIONS_PTY_NAME $'\t'
	fi

	{
		# The completion result is surrounded by null bytes, so read the
		# content between the first two null bytes.
		zpty -r $ZSH_AUTOSUGGEST_COMPLETIONS_PTY_NAME line '*'$'\0''*'$'\0'

		# Extract the suggestion from between the null bytes.  On older
		# versions of zsh (older than 5.3), we sometimes get extra bytes after
		# the second null byte, so trim those off the end.
		# See http://www.zsh.org/mla/workers/2015/msg03290.html
		suggestion="${${(@0)line}[2]}"
	} always {
		# Destroy the pty
		zpty -d $ZSH_AUTOSUGGEST_COMPLETIONS_PTY_NAME
	}
}
