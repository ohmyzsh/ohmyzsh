# Adds support for a ${ZDOTDIR:-$HOME}/.zfunc.d directory to contain
# lazy-loaded zsh functions

ZFUNCDIR="${ZFUNCDIR:-${ZDOTDIR:-~}/.zfunctions}"
[[ -d "$ZFUNCDIR" ]] || mkdir -p "$ZFUNCDIR"

fpath=("$ZFUNCDIR" $fpath)
for _zfunc in "$ZFUNCDIR"/*(.N); do
  autoload -Uz "$_zfunc"
done
unset _zfunc

function funcsave {
  ### save a function to $ZFUNCDIR for lazy loading
  local zfuncdir="${ZFUNCDIR:-${ZDOTDIR:-~}/.zfunctions}"

  # check args
  if [[ -z "$1" ]]; then
    echo "funcsave: Expected function name argument" >&2 && return 1
  elif ! typeset -f "$1" > /dev/null; then
    echo "funcsave: Unknown function '$1'" >&2 && return 1
  fi

  # make sure the function is loaded in case it's already lazy
  autoload +X "$1" > /dev/null

  # remove first/last lines (ie: 'function foo {' and '}') and de-indent one level
  type -f "$1" | awk 'NR>2 {print prev} {gsub(/^\t/, "", $0); prev=$0}' >| "$zfuncdir/$1"
}

function funced {
  ### edit the function specified
  local zfuncdir="${ZFUNCDIR:-${ZDOTDIR:-~}/.zfunctions}"

  # check args
  if [[ -z "$1" ]]; then
    echo "funced: Expected function name argument" >&2 && return 1
  fi

  # new function definition: make a file template
  if [[ ! -f "$zfuncdir/$1" ]]; then
    cat <<eos > "$zfuncdir/$1"
# Add function internals here.
# Do NOT include function definition (ie: omit 'function $1() {').
# See: http://zsh.sourceforge.net/Doc/Release/Functions.html#Autoloading-Functions
eos
  fi

  # open the function file
  if [[ -z "$VISUAL" ]]; then
    $VISUAL "$zfuncdir/$1"
  else
    ${EDITOR:-nano} "$zfuncdir/$1"
  fi
}
