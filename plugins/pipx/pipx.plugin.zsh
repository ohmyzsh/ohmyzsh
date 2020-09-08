# check if pipx is installed
if (( ! ${+commands[pipx]} )); then
  return
fi

autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete pipx)"