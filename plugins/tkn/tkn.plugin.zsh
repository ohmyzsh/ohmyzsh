# Autocompletion for tkn, the command line interface for Tekton Cloud Natice CI/CD (https://tekton.dev/)
# Author: https://github.com/jvarela01

if [ $commands[tkn] ]; then
  source <(tkn completion zsh)
  compdef _tkn tkn
fi