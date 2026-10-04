# enables cycling through the directory stack using
# Ctrl+Shift+Left/Right
#
# left/right direction follows the order in which directories
# were visited, like left/right arrows do in a browser

# NO_PUSHD_MINUS syntax:
#  pushd +N: start counting from left of `dirs' output
#  pushd -N: start counting from right of `dirs' output

# Either switch to a directory from dirstack, using +N or -N syntax
# or switch to a directory by path, using `switch-to-dir -- <path>`
switch-to-dir () {
	# If $1 is --, then treat $2 as a directory path
	if [[ $1 == -- ]]; then
		# We use `-q` because we don't want chpwd to run, we'll do it manually
		[[ -d "$2" ]] && builtin pushd -q "$2" &>/dev/null
		return $?
	fi

	setopt localoptions nopushdminus
	[[ ${#dirstack} -eq 0 ]] && return 1

	while ! builtin pushd -q $1 &>/dev/null; do
		# We found a missing directory: pop it out of the dir stack
		builtin popd -q $1

		# Stop trying if there are no more directories in the dir stack
		[[ ${#dirstack} -eq 0 ]] && return 1
	done
}

insert-cycledleft () {
	switch-to-dir +1 || return $?

	local fn
	for fn in chpwd $chpwd_functions precmd $precmd_functions; do
		(( $+functions[$fn] )) && $fn
	done
	zle reset-prompt
}
zle -N insert-cycledleft

insert-cycledright () {
	switch-to-dir -0 || return $?

	local fn
	for fn in chpwd $chpwd_functions precmd $precmd_functions; do
		(( $+functions[$fn] )) && $fn
	done
	zle reset-prompt
}
zle -N insert-cycledright

insert-cycledup () {
	switch-to-dir -- .. || return $?

	local fn
	for fn in chpwd $chpwd_functions precmd $precmd_functions; do
		(( $+functions[$fn] )) && $fn
	done
	zle reset-prompt
}
zle -N insert-cycledup

insert-cycleddown () {
	switch-to-dir -- "$(find . -mindepth 1 -maxdepth 1 -type d | sort -n | head -n 1)" || return $?

	local fn
	for fn in chpwd $chpwd_functions precmd $precmd_functions; do
		(( $+functions[$fn] )) && $fn
	done
	zle reset-prompt
}
zle -N insert-cycleddown

# These sequences work for xterm, Apple Terminal.app, and probably others.
# Not for rxvt-unicode, but it doesn't seem differentiate Ctrl-Shift-Arrow
# from plain Shift-Arrow, at least by default.
#
# iTerm2 does not have these key combinations defined by default; you will need
# to add them under "Keys" in your profile if you want to use this. You can do
# this conveniently by loading the "xterm with Numeric Keypad" preset.
bindkey "\e[1;6D" insert-cycledleft     # Ctrl+Shift+Left
bindkey "\e[1;6C" insert-cycledright    # Ctrl+Shift+Right
bindkey "\e[1;6A" insert-cycledup       # Ctrl+Shift+Up
bindkey "\e[1;6B" insert-cycleddown     # Ctrl+Shift+Down
