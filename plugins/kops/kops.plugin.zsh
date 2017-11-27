# Autocompletion for kops (Kubernetes Operations),
# the command line interface to get a production grade
# Kubernetes cluster up and running

# Author: https://github.com/nmrony

if [ $commands[kops] ]; then
  source <(kops completion zsh)
fi
