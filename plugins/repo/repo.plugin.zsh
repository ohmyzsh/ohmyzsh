alias r='repo'
alias rra='repo rebase --auto-stash'
alias rs='repo sync -j5'
alias rs.='repo sync .'

alias rra.='repo rebase --auto-stash .'
alias rsrra='repo sync -j5 ; repo rebase --auto-stash'
alias rsrra.='repo sync . ; repo rebase --auto-stash .'
alias ru='repo upload'
alias rst='repo status'
alias rsto='repo status -o'

alias ruc='repo upload --cbr .'
alias yruc='yes | repo upload --cbr .'

alias rucy='yes | repo upload --cbr .'

# Repo start current branch on all projects
alias rscb='echo "Starting branch $(git branch | sed -n "/\* /s///p") on all projects" && repo start $(git branch | sed -n "/\* /s///p") --all'

# Repo start and rebase current branch on all projects
alias rscbrra='echo "Starting & Rebasing branch $(git branch | sed -n "/\* /s///p") on all projects" && rscb && echo "Rebasing..." && rra'

# Repo start and rebase current branch on all projects
alias rscbrsrra='echo "Starting & Rebasing branch $(git branch | sed -n "/\* /s///p") on all projects" && rscb && echo "Sync & Rebasing..." && rsrra'

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
