#!/bin/zsh

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

alias ss='thin --stats "/thin/stats" start'
alias devlog='tail -f log/development.log'

# Super user
alias _='sudo'
alias ss='sudo su -'

# Show history
alias history='fc -l 1'

# TextMate
alias et='mate . &'
