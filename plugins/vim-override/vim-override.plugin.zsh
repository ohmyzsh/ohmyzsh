# try to replace OSX's default vim by MacVim's version
RECENTVIM=`test -e /usr/local/Cellar/macvim && find /usr/local/Cellar/macvim -name Vim`

# if mode indicator wasn't setup by theme, define default
if [[ "$OSTYPE" == darwin* && -e $RECENTVIM ]]; then
  alias vim="$RECENTVIM"
fi
