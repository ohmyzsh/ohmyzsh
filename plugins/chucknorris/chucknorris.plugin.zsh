# chucknorris: Chuck Norris fortunes

# Automatically generate or update Chuck's compiled fortune data file
# $0 must be used outside a local function. This variable name is unlikly to collide.
CHUCKNORRIS_PLUGIN_DIR=${0:h}

() {
local DIR=$CHUCKNORRIS_PLUGIN_DIR/fortunes
if [[ ! -f $DIR/chucknorris.dat ]] || [[ $DIR/chucknorris.dat -ot $DIR/chucknorris ]]; then
  # For some reason, Cygwin puts strfile in /usr/sbin, which is not on the path by default
  local strfile=strfile
  if ! which strfile &>/dev/null && [[ -f /usr/sbin/strfile ]]; then
    strfile=/usr/sbin/strfile
  fi
  if which $strfile &> /dev/null; then
    $strfile $DIR/chucknorris $DIR/chucknorris.dat >/dev/null
  else
    echo "[oh-my-zsh] chucknorris depends on strfile, which is not installed" >&2
    echo "[oh-my-zsh] strfile is often provided as part of the 'fortune' package" >&2
  fi
fi

# Aliases
alias chuck="fortune -a $DIR"
alias chuck_cow="chuck | cowthink"
}

unset CHUCKNORRIS_PLUGIN_DIR
