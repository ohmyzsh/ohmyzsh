function knife_ssh() {
<<<<<<< HEAD
  grep -q $1 ~/.knife_comp~ 2> /dev/null || rm -f ~/.knife_comp~;
=======
  grep -q $1 ~/.knife_comp~ 2> /dev/null || rm -f ~/.knife_comp~
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  ssh $(knife node show $1 | awk '/IP:/{print $2}')
}

_knife_ssh() {
  if hash knife 2>/dev/null; then
    if [[ ! -f ~/.knife_comp~ ]]; then
<<<<<<< HEAD
      echo "\nGenerating ~/.knife_comp~..." >/dev/stderr
      knife node list > ~/.knife_comp~
    fi
    compadd $(<~/.knife_comp~)
  else
    echo "Could not find knife" > /dev/stderr;
=======
      echo "\nGenerating ~/.knife_comp~..." >&2
      knife node list > ~/.knife_comp~
    fi
    compadd $(< ~/.knife_comp~)
  else
    echo "Could not find knife" >&2
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  fi
}

compdef _knife_ssh knife_ssh
