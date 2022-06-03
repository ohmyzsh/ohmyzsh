# Autocompletion for nerdctl, docker-compatible CLI for containerd
#
# nerdctl project: https://github.com/containerd/nerdctl

if [ $commands[nerdctl] ]; then
  source <(nerdctl completion zsh)
fi