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
  if [[ -z $1 ]]; then
    echo "Error: no mark required"
    return
  fi
  if [[ $1 == "--help" ]]; then
    echo "Jump plugin:"
    echo "  'jump FOO': jump to a mark named FOO"
    echo "  'mark FOO': create a mark named FOO"
    echo "  'unmark FOO': delete a mark"
    echo "  'marks': lists all marks"
    return
  fi
	cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark { 
	mkdir -p "$MARKPATH"; ln -s "$(pwd)" $MARKPATH/$1
}
function unmark { 
	rm -i "$MARKPATH/$1"
}
function marks {
	if [[ -d $MARKPATH ]]; then
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
  else
    echo "No mark directory"
  fi
}

function _completemarks {
  reply=($(ls $MARKPATH))
}

compctl -K _completemarks jump
compctl -K _completemarks unmark

alias j='jump'
compdef _jump j=jump

