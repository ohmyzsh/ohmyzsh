# try to replace OSX's default vim by MacVim's version
MACVIM="/usr/local/bin/mvim"

# if mode indicator wasn't setup by theme, define default
if [[ "$OSTYPE" == darwin* && -e $MACVIM ]]; then
  alias vim="$MACVIM -v"
fi
