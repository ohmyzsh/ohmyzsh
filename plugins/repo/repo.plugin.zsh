# Aliases
alias r='repo'
compdef _repo r=repo

alias rra='repo rebase --auto-stash'
compdef _repo rra='repo rebase --auto-stash'

alias rs='repo sync'
compdef _repo rs='repo sync'

alias rsrra='repo sync ; repo rebase --auto-stash'
compdef _repo rsrra='repo sync ; repo rebase --auto-stash'
