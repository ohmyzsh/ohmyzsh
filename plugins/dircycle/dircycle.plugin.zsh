# enables cycling through the directory stack using
# Ctrl+Shift+Left/Right
#
# left/right direction follows the order in which directories
# were visited, like left/right arrows do in a browser

# NO_PUSHD_MINUS syntax:
#  pushd +N: start counting from left of `dirs' output
#  pushd -N: start counting from right of `dirs' output
setopt nopushdminus

insert-cycledleft () {
	zle push-line
	LBUFFER='pushd -q +1'
	zle accept-line
}
zle -N insert-cycledleft

insert-cycledright () {
	zle push-line
	LBUFFER='pushd -q -0'
	zle accept-line
}
zle -N insert-cycledright

bindkey "\e[1;6D" insert-cycledleft
bindkey "\e[1;6C" insert-cycledright
