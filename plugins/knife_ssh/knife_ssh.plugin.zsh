function knife_ssh() {
  grep -q $1 ~/.knife_comp~ 2> /dev/null || rm -f ~/.knife_comp~
  ssh $(knife node show $1 | awk '/IP:/{print $2}')
}

_knife_ssh() {
  if hash knife 2>/dev/null; then
    if [[ ! -f ~/.knife_comp~ ]]; then
      echo "\nGenerating ~/.knife_comp~..." >&2
      knife node list > ~/.knife_comp~
    fi
    compadd $(< ~/.knife_comp~)
  else
    echo "Could not find knife" >&2
  fi
}

compdef _knife_ssh knife_ssh
