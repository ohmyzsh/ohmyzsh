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


# These sequences work for xterm, Apple Terminal.app, and probably others.
# Not for rxvt-unicode, but it doesn't seem differentiate Ctrl-Shift-Arrow
# from plain Shift-Arrow, at least by default.
# iTerm2 does not have these key combinations defined by default; you will need
# to add them under "Keys" in your profile if you want to use this. You can do
# this conveniently by loading the "xterm with Numeric Keypad" preset.
bindkey "\e[1;6D" insert-cycledleft
bindkey "\e[1;6C" insert-cycledright
