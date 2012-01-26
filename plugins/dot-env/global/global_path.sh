paths=(
/bin
/sbin
/usr/local/bin
/usr/local/sbin
/usr/bin
/usr/sbin
/usr/X11/bin
)

EGREP=`which egrep`
function pathmunge () {
	# If it exists then remove it so we can shuffle it to the end or beginning of the PATH
	if echo $PATH | $EGREP "(^|:)$1($|:)" > /dev/null ; then
		safe_param=$(printf "%s\n" "$1" | sed 's/[][\.*^$(){}?+|/]/\\&/g')
		PATH=`echo $PATH | sed -Ee "s/(^|:)$safe_param($|:)/:/"`
	fi
	# add the path in the apropriate location
	if [ -d "$1" ]; then
		if [ "$2" = "before" ] ; then
			PATH="$1:$PATH"
		else
			PATH="$PATH:$1"
		fi
	fi
}

for p in $paths; do
	pathmunge $p
done

# Prepend path with $HOME/bin
pathmunge "$HOME/bin" before

# Remove : at the beginning and duplicate ::
PATH=`echo $PATH | sed -e 's/^\://' -e 's/\:\:/:/g'`
unset paths
export PATH
