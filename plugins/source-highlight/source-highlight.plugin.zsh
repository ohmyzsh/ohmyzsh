spath=$(which src-hilite-lesspipe.sh 2>/dev/null)
if [ $spath ]; then
	export LESSOPEN="| $spath  %s"
	export LESS=' -R '
fi
