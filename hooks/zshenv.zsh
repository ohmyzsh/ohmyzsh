omzp:start() {
  setopt localoptions localtraps

  # initialization
  zmodload zsh/datetime
  typeset -Ag __OMZP
  __OMZP=(
    PS4     "$PS4" 
    start   "$EPOCHREALTIME"
    outfile "${1:-$HOME}/${${SHELL:t}#-}.$EPOCHSECONDS.$$.zsh-trace.log"
  )
  typeset -g PS4="+Z|%e|%D{%s.%9.}|%N|%x|%I> "

  # unload profiler on startup end
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd omzp:stop

  # redirect debug output to profiler log file
  exec 3>&2 2>${__OMZP[outfile]}

  # enable zsh debug mode
  trap 'setopt xtrace noevallineno' EXIT
}

# Force this function to be executed in noxtrace mode
emulate zsh +x -c '
omzp:stop() {
  setopt localoptions localtraps
  trap "{ setopt noxtrace evallineno } 2>/dev/null; exec 2>&3 3>&-" EXIT

  # restore PS4
  typeset -g PS4="$__OMZP[PS4]"
  unset "__OMZP[PS4]"

  # remove precmd function
  add-zsh-hook -d precmd omzp:stop
  unfunction omzp:stop

  local startup=$(( (${(%):-"%D{%s.%9.}"} - __OMZP[start]) * 1e3 ))
  printf "%.3f ms – %s \n" "$startup" "${__OMZP[outfile]:t}"
}'

# TODO: this is duplicated from init script, fix later
# Init $ZSH path
[[ -n "$ZSH" ]] || export ZSH="${${(%):-%x}:a:h:h}"

# Set ZSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
[[ -n "$ZSH_CACHE_DIR" ]] || ZSH_CACHE_DIR="$ZSH/cache"

# Make sure $ZSH_CACHE_DIR is writable, otherwise use a directory in $HOME
if [[ ! -w "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
fi

# Set OMZ_TRACES directory
OMZ_TRACES="${OMZ_TRACES:-"$ZSH_CACHE_DIR/.traces"}"
! 'builtin' 'test' -f "${OMZ_TRACES}/.enabled" || omzp:start "$OMZ_TRACES"
