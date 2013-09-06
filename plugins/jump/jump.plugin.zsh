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
	cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

mark() {
	DIR="$(pwd)"
	if (( $# == 0 )); then
		MARK=$(basename $DIR)
	else
		MARK=$1
	fi
	if read -q \?"Mark ${DIR} as ${MARK}? (y/n) "; then
		mkdir -p "$MARKPATH"; ln -s "${DIR}" "$MARKPATH/$MARK"
	fi
}

unmark() {
	rm -i "$MARKPATH/$1"
}

autoload colors
marks() {
	for link in $MARKPATH/*(@); do
		local markname="$fg[cyan]${link:t}$reset_color"
		local markpath="$fg[blue]$(readlink $link)$reset_color"
		printf "%s\t" $markname
		printf "-> %s \t\n" $markpath
	done
}

_completemarks() {
	reply=($(ls $MARKPATH/**/*(-) | grep : | sed -E 's/(.*)\/([_\da-zA-Z\-]*):$/\2/g'))
}
compctl -K _completemarks jump
compctl -K _completemarks unmark

_mark_expansion() {
	setopt extendedglob
	autoload -U modify-current-argument
	modify-current-argument '$(readlink "$MARKPATH/$ARG")'
}
zle -N _mark_expansion
bindkey "^g" _mark_expansion
