# Autocompletion for velero.
#
# Copy from helm plugin : https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/helm

if [ $commands[velero] ]; then
  source <(velero completion zsh)
fi
