if (( ! $+commands[rbw] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `rbw`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_rbw" ]]; then
  typeset -g -A _comps
  autoload -Uz _rbw
  _comps[rbw]=_rbw
fi

rbw gen-completions zsh >| "$ZSH_CACHE_DIR/completions/_rbw" &|

# rbwpw function copies the password of a service to the clipboard
# and clears it after 20 seconds
function rbwpw {
  if [[ $# -ne 1 ]]; then
    echo "usage: rbwpw <service>"
    return 1
  fi
  local service=$1
  if ! rbw unlock; then
    echo "rbw is locked"
    return 1
  fi
  local pw=$(rbw get $service 2>/dev/null)
  if [[ -z $pw ]]; then
    echo "$service not found"
    return 1
  fi

  # Generate a random identifier for this call to rbwpw
  # so we can check if the clipboard content has changed
  local _random="$RANDOM" _cache="$ZSH_CACHE_DIR/.rbwpw"
  echo -n "$_random" > "$_cache"

  # Use clipcopy to copy the password to the clipboard
  echo -n $pw | clipcopy
  echo "password for $service copied!"

  # Clear the clipboard after 20 seconds, but only if the clipboard hasn't
  # changed (if rbwpw hasn't been called again)
  {
    sleep 20 \
    && [[ "$(<"$_cache")" == "$_random" ]] \
    && clipcopy </dev/null 2>/dev/null \
    && command rm -f "$_cache" &>/dev/null
  } &|
}

function _rbwpw {
  local -a services
  services=("${(@f)$(rbw ls 2>/dev/null)}")
  [[ -n "$services" ]] && compadd -a -- services
}

compdef _rbwpw rbwpw
