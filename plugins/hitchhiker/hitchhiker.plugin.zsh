# hitchhiker: Hitchhiker's Guide to the Galaxy fortunes

# Automatically generate or update Hitchhicker's compiled fortune data file
# $0 must be used outside a local function. This variable name is unlikly to collide.
HITCHHIKER_PLUGIN_DIR=${0:h}

() {
local DIR=$HITCHHIKER_PLUGIN_DIR/fortunes
if [[ ! -f $DIR/hitchhiker.dat ]] || [[ $DIR/hitchhiker.dat -ot $DIR/hitchhiker ]]; then
  # For some reason, Cygwin puts strfile in /usr/sbin, which is not on the path by default
  local strfile=strfile
  if ! which strfile &>/dev/null && [[ -f /usr/sbin/strfile ]]; then
    strfile=/usr/sbin/strfile
  fi
  if which $strfile &> /dev/null; then
    $strfile $DIR/hitchhiker $DIR/hitchhiker.dat >/dev/null
  else
    echo "[oh-my-zsh] hitchhiker depends on strfile, which is not installed" >&2
    echo "[oh-my-zsh] strfile is often provided as part of the 'fortune' package" >&2
  fi
fi

# Aliases
alias hitchhiker="fortune -a $DIR"
alias hitchiker_cow="chuck | cowthink"
}

unset HITCHHIKER_PLUGIN_DIR
