# enables cycling through the directory stack using
# Ctrl+Shift+Left/Right
#
# left/right direction follows the order in which directories
# were visited, like left/right arrows do in a browser

# NO_PUSHD_MINUS syntax:
#  pushd +N: start counting from left of `dirs' output
#  pushd -N: start counting from right of `dirs' output

insert-cycledleft () {
	emulate -L zsh
	setopt nopushdminus

	builtin pushd -q +1 &>/dev/null || true
	zle reset-prompt
}
zle -N insert-cycledleft

insert-cycledright () {
	emulate -L zsh
	setopt nopushdminus

	builtin pushd -q -0 &>/dev/null || true
	zle reset-prompt
}
zle -N insert-cycledright


# add key bindings for iTerm2
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
	bindkey "^[[1;6D" insert-cycledleft
	bindkey "^[[1;6C" insert-cycledright
else
	bindkey "\e[1;6D" insert-cycledleft
	bindkey "\e[1;6C" insert-cycledright
fi