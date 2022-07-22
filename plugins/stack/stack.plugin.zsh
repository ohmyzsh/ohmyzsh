(( $+commands[stack] )) || return

autoload -U +X bashcompinit && bashcompinit
source <(stack --bash-completion-script stack)
