# enables cycling through the directory stack using
# Ctrl+Shift+Left/Right
#
# left/right direction follows the order in which directories
# were visited, like left/right arrows do in a browser

# NO_PUSHD_MINUS syntax:
#  pushd +N: start counting from left of `dirs' output
#  pushd -N: start counting from right of `dirs' output

<<<<<<< HEAD
insert-cycledleft () {
	emulate -L zsh
	setopt nopushdminus

	builtin pushd -q +1 &>/dev/null || true
=======
switch-to-dir () {
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
	switch-to-dir +1 || return

	local fn
	for fn (chpwd $chpwd_functions precmd $precmd_functions); do
		(( $+functions[$fn] )) && $fn
	done
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
	zle reset-prompt
}
zle -N insert-cycledleft

insert-cycledright () {
<<<<<<< HEAD
	emulate -L zsh
	setopt nopushdminus

	builtin pushd -q -0 &>/dev/null || true
=======
	switch-to-dir -0 || return

	local fn
	for fn (chpwd $chpwd_functions precmd $precmd_functions); do
		(( $+functions[$fn] )) && $fn
	done
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
	zle reset-prompt
}
zle -N insert-cycledright


<<<<<<< HEAD
# add key bindings for iTerm2
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
	bindkey "^[[1;6D" insert-cycledleft
	bindkey "^[[1;6C" insert-cycledright
else
	bindkey "\e[1;6D" insert-cycledleft
	bindkey "\e[1;6C" insert-cycledright
fi
=======
# These sequences work for xterm, Apple Terminal.app, and probably others.
# Not for rxvt-unicode, but it doesn't seem differentiate Ctrl-Shift-Arrow
# from plain Shift-Arrow, at least by default.
# iTerm2 does not have these key combinations defined by default; you will need
# to add them under "Keys" in your profile if you want to use this. You can do
# this conveniently by loading the "xterm with Numeric Keypad" preset.
bindkey "\e[1;6D" insert-cycledleft
bindkey "\e[1;6C" insert-cycledright
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
