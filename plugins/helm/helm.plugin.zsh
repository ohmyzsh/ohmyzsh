# Autocompletion for helm.
#
# Copy from kubectl : https://github.com/pstadler

if [ $commands[helm] ]; then
  source <(helm completion zsh)
fi
