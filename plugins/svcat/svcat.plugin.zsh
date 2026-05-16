# Autocompletion for svcat.
#

if [ $commands[svcat] ]; then
  source <(svcat completion zsh)
fi
