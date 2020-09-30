# ------------------------------------------------------------------------------
#          FILE:  compleat.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Sorin Ionescu (sorin.ionescu@gmail.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

if (( ${+commands[compleat]} )); then
  local prefix="${commands[compleat]:h:h}"
  local setup="${prefix}/share/compleat-1.0/compleat_setup" 

  if [[ -f "$setup" ]]; then
    source "$setup" 
  fi

  unset prefix setup
fi
