# check if pipx is installed
if (( ! ${+commands[pipx]} )); then
  return
fi

eval "$(register-python-argcomplete pipx)"
