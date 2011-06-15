if [ -f `/usr/local/bin/src-hilite-lesspipe.sh`]; then
	export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh  %s"
	export LESS=' -R '
fi
