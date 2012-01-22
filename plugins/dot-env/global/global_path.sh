paths="${DOT_ENV_PATH}/bin
/sbin
/bin
/usr/X11/bin
/usr/local/bin
/usr/sbin
/usr/bin"

EGREP=`which egrep`
function pathmunge () {
	if ! echo $PATH | $EGREP "(^|:)$1($|:)" > /dev/null ; then
		if [ -d "$1" ]; then
			if [ "$2" = "before" ] ; then
				PATH="$1:$PATH"
			else
				PATH="$PATH:$1"
			fi
		fi
	fi
}

for p in $paths; do
	pathmunge $p
done

# Prepend path with $HOME/bin
pathmunge "$HOME/bin" before

PATH=`echo $PATH | sed -e 's/^\://' -e 's/\:\:/:/g'`
unset paths
export PATH
