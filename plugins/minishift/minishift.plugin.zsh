# Autocompletion plugin for minishift.

if [ $commands[minishift] ]; then
  source <(minishift completion zsh)
fi
