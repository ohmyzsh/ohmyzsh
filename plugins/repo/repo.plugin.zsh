<<<<<<< HEAD
# Aliases
alias r='repo'
compdef _repo r=repo

alias rra='repo rebase --auto-stash'
compdef _repo rra='repo rebase --auto-stash'

alias rs='repo sync'
compdef _repo rs='repo sync'

alias rsrra='repo sync ; repo rebase --auto-stash'
compdef _repo rsrra='repo sync ; repo rebase --auto-stash'

alias ru='repo upload'
compdef _repo ru='repo upload'

alias rst='repo status'
compdef _repo rst='repo status'
=======
alias r='repo'
alias rra='repo rebase --auto-stash'
alias rs='repo sync'
alias rsrra='repo sync ; repo rebase --auto-stash'
alias ru='repo upload'
alias rst='repo status'
alias rsto='repo status -o'
alias rfa='repo forall -c'
alias rfap='repo forall -p -c'
alias rinf='repo info'
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
