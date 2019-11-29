# Adds support for a ${ZDOTDIR:-$HOME}/.zfunc.d directory to contain
# lazy-loaded zsh functions

[[ -n "$ZFUNCDIR" ]] || ZFUNCDIR="${ZDOTDIR:-$HOME}"/.zfunc.d
[[ -d "$ZFUNCDIR" ]] || mkdir -p "$ZFUNCDIR"

fpath=("$ZFUNCDIR" $fpath)
for _zfunc in "$ZFUNCDIR"/*(.N); do
  autoload -Uz "$_zfunc"
done
unset _zfunc

function funcsave {
  ### save a function to ~/.ZFUNCDIR for lazy loading

  # check args
  if [[ -z "$1" ]]; then
    echo "funcsave: Expected function name argument" >&2 && return 1
  elif ! typeset -f "$1" > /dev/null; then
    echo "funcsave: Unknown function '$1'" >&2 && return 1
  fi

  # make sure the function is loaded in case it's already lazy
  autoload +X "$1" > /dev/null

  # remove first/last lines (ie: 'function foo {' and '}') and de-indent one level
  type -f "$1" | awk 'NR>2 {print prev} {gsub(/^\t/, "", $0); prev=$0}' >| "$ZFUNCDIR/$1"
}

function funced {
  ### edit the function specified

  # check args
  if [[ -z "$1" ]]; then
    echo "funced: Expected function name argument" >&2 && return 1
  fi

  # new function definition: make a file template
  if [[ ! -f "$ZFUNCDIR/$1" ]]; then
    cat <<eos > "$ZFUNCDIR/$1"
# Add function internals here.
# Do NOT include function definition (ie: omit 'function $1() {').
# See: http://zsh.sourceforge.net/Doc/Release/Functions.html#Autoloading-Functions
eos
  fi

  # open the function file
  if [[ -z "$VISUAL" ]]; then
    $VISUAL "$ZFUNCDIR/$1"
  else
    ${EDITOR:-nano} "$ZFUNCDIR/$1"
  fi
}
