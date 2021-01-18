if (( ${+commands[op]} )); then
  eval "$(op completion zsh)"
  compdef _op op
fi

# opswd puts the password of the named service into the clipboard. If there's a
# one time password, it will be copied into the clipboard after 5 seconds. The
# clipboard is cleared after another 10 seconds.
function opswd() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: opswd <service>"
    return 1
  fi

  local service=$1

  # If not logged in, print error and return
  op list users > /dev/null || return

  op get item "$service" \
  | jq -r '.details.fields[] | select(.designation=="password").value' \
  | clipcopy

  (
    sleep 5 && op get totp "$service" 2>/dev/null | clipcopy 2>/dev/null
    sleep 10 && clipcopy < /dev/null 2>/dev/null &
  ) &!
}

function _opswd() {
  local -a services
  services=("${(@f)$(op list items --categories Login 2>/dev/null | jq -r '.[].overview.title')}")
  [[ -z "$services" ]] || compadd -a -- services
}

compdef _opswd opswd
