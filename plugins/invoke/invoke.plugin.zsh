# Autocompletion for invoke.
#
if [ $commands[invoke] ]; then
  source <(invoke --print-completion-script=zsh)
fi
