# Aliases
alias r='repo'
compdef _repo r=repo

alias rra='repo rebase --auto-stash'
compdef _repo rra='repo rebase --auto-stash'

alias rs='repo sync -j5'
compdef _repo rs='repo sync'

alias rs.='repo sync .'
compdef _repo rs.='repo sync'

alias rra.='repo rebase --auto-stash .'
compdef _repo rra.='repo rebase'

alias rsrra='repo sync -j5 ; repo rebase --auto-stash'
compdef _repo rsrra='repo rebase'

alias rsrra.='repo sync . ; repo rebase --auto-stash .'
compdef _repo rsrra.='repo rebase'

alias ru='repo upload'
compdef _repo ru='repo upload'

alias rst='repo status'
compdef _repo rst='repo status'

alias ruc='repo upload --cbr .'
compdef _repo ruc='repo upload'

alias yruc='yes | repo upload --cbr .'
compdef _repo ruc='repo upload'

# Repo start current branch on all projects
alias rscb='echo "Starting branch $(git branch | sed -n "/\* /s///p") on all projects" && repo start $(git branch | sed -n "/\* /s///p") --all'
compdef _repo rscb='repo start'

# Repo start and rebase current branch on all projects
alias rscbrra='echo "Starting & Rebasing branch $(git branch | sed -n "/\* /s///p") on all projects" && rscb && echo "Rebasing..." && rra'
compdef _repo rscbrra='repo rebase'

# Repo start and rebase current branch on all projects
alias rscbrsrra='echo "Starting & Rebasing branch $(git branch | sed -n "/\* /s///p") on all projects" && rscb && echo "Sync & Rebasing..." && rsrra'
compdef _repo rscbrsrra='repo rebase'

function rsbrra()
{
    if [[ -z $1 ]]; then
        echo "usage: rsbrra <branch name>"
        exit 1
    fi
    echo "Starting branch $1 and syncing up all project (repo rebase)"
    repo start $1 --all
    repo rebase --auto-stash
}

function rsbrsrra()
{
    if [[ -z $1 ]]; then
        echo "usage: rsbrsrra <branch name>"
        exit 1
    fi
    echo "Starting branch $1 and syncing up all project (repo rebase)"
    repo start $1 --all || return 1
    repo sync -j5 || return 1
    repo rebase --auto-stash || return 1
}
