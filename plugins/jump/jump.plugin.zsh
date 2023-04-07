# Easily jump around the file system by manually adding marks
# marks are stored as symbolic links in the directory $MARKPATH (default $HOME/.marks)
#
# jump FOO: jump to a mark named FOO
# mark FOO: create a mark named FOO
# unmark FOO: delete a mark
# marks: lists all marks
#
export MARKPATH=$HOME/.marks

jump() {
	builtin cd -P "$MARKPATH/$1" 2>/dev/null || {echo "No such mark: $1"; return 1}
}

mark() {
	if [[ $# -eq 0 || "$1" = "." ]]; then
		MARK=${PWD:t}
	else
		MARK="$1"
	fi
	if read -q "?Mark $PWD as ${MARK}? (y/n) "; then
		command mkdir -p "$MARKPATH"
		command ln -sfn "$PWD" "$MARKPATH/$MARK"
	fi
}

unmark() {
	LANG= command rm -i "$MARKPATH/$1"
}

marks() {
	local link max=0
	for link in $MARKPATH/{,.}*(@N); do
		if [[ ${#link:t} -gt $max ]]; then
			max=${#link:t}
		fi
	done
	local printf_markname_template="$(printf -- "%%%us" "$max")"
	for link in $MARKPATH/{,.}*(@N); do
		local markname="$fg[cyan]$(printf -- "$printf_markname_template" "${link:t}")$reset_color"
		local markpath="$fg[blue]$(readlink $link)$reset_color"
		printf -- "%s -> %s\n" "$markname" "$markpath"
	done
}

_completemarks() {
	reply=("${MARKPATH}"/{,.}*(@N:t))
}
compctl -K _completemarks jump
compctl -K _completemarks unmark

_mark_expansion() {
	setopt localoptions extendedglob
	autoload -U modify-current-argument
	modify-current-argument '$(readlink "$MARKPATH/$ARG" || echo "$ARG")'
}
zle -N _mark_expansion
bindkey "^g" _mark_expansion
