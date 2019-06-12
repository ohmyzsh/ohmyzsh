# Autocompletion plugin for [s2i](https://github.com/openshift/source-to-image).

if [ $commands[s2i] ]; then
  source <(s2i completion zsh)
fi
