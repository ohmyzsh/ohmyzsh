if (( ! $+commands[claude] )); then
  return
fi

alias cc='claude'
alias ccx='claude --continue'
alias ccr='claude --resume'
alias ccp='claude --print'
alias ccm='claude --model'
alias cch='claude --help'