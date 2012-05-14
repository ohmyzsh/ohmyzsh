# try to replace OSX's default vim by MacVim's version
RECENTVIM=`find /usr/local/Cellar/macvim -name Vim`

# if mode indicator wasn't setup by theme, define default
if [[ "$OSTYPE" == darwin* && -e $RECENTVIM ]]; then
	echo "Redirecionando vim..."
  alias vim="$RECENTVIM"
else
	echo "deu zica criando alias"
fi
