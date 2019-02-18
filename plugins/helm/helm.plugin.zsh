# Autocompletion for helm.
#
# Copy from kubectl : https://github.com/pstadler

if [ $commands[helm] ]; then
  source <(helm completion zsh | sed -E 's/\["(.+)"\]/\[\1\]/g')
fi
