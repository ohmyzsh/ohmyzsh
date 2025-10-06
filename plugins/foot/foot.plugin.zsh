function precmd {
  print -Pn "\e]133;A\e\\"
  if ! builtin zle; then
    print -n "\e]133;D\e\\"
  fi
}

function preexec {
  print -n "\e]133;C\e\\"
}
