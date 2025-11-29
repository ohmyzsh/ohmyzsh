# Ensure compinit is available
autoload -Uz compinit
if ! typeset -f _completion_loader >/dev/null; then
  compinit -u
fi

# Load our completion function
fpath=(${0:A:h} $fpath)
autoload -Uz _claude
compdef _claude claude
