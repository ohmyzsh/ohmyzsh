alias rs='repo sync'
compdef _repo rs='repo sync'

alias rsa='repo sync -a'

alias rs.='repo sync .'
compdef _repo rs.='repo sync'

alias rsa.='repo sync -a .'

alias rsrra='repo sync ; repo rebase --auto-stash'
alias rsarra='repo sync -a ; repo rebase --auto-stash'
compdef _repo rsrra='repo rebase'

alias rsrra.='repo sync .; repo rebase --auto-stash .'
alias rsarra.='repo sync -a . ; repo rebase --auto-stash .'
compdef _repo rsrra.='repo rebase'

alias gPoHrfm='git push origin HEAD:refs/for/master'
alias git-push-refs-for-master='git push origin HEAD:refs/for/master'

function rsbrsrra()
{
    if [[ -z $1 ]]; then
        echo "usage: rsbrsrra <branch name>"
        exit 1
    fi
    echo "Starting branch $1 and syncing up all project (repo rebase)"
    repo start $1 --all || return 1
    repo sync -a || return 1
    repo rebase --auto-stash || return 1
}

alias rclean="repo forall -c 'git remote prune umg'"
compdef _repo rclean='repo forall'
