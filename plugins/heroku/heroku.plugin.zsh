HEROKU_AC_CACHE_DIR="$HOME/.cache"
if [ "$(uname -s)" = "Darwin" ]; then
  HEROKU_AC_CACHE_DIR="$HOME/Library/Caches"
fi
if [ ! -z "$XDG_CACHE_HOME" ]; then
  HEROKU_AC_CACHE_DIR="$XDG_CACHE_DIR"
fi
HEROKU_AC_ZSH_SETUP_PATH=$HEROKU_AC_CACHE_DIR/heroku/autocomplete/zsh_setup
[ -f $HEROKU_AC_ZSH_SETUP_PATH ] && source $HEROKU_AC_ZSH_SETUP_PATH
