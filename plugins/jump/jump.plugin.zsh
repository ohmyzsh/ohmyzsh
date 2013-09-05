# Easily jump around the file system by manually adding marks
# marks are stored as symbolic links in the directory $MARKPATH (default $HOME/.marks)
#
# jump FOO: jump to a mark named FOO
# mark FOO: create a mark named FOO
# unmark FOO: delete a mark
# marks: lists all marks
#
export MARKPATH=$HOME/.marks
function jump {
	cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
	mkdir -p "$MARKPATH"; ln -s "$(pwd)" $MARKPATH/$1
}
function unmark {
	rm -i "$MARKPATH/$1"
}
function marks {
	ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

function _completemarks {
  reply=($(ls $MARKPATH/**/*(-) | grep : | sed -E 's/(.*)\/([a-z]*):$/\2/g'))
}

compctl -K _completemarks jump
compctl -K _completemarks unmark
