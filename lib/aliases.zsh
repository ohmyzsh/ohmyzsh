# Helper function that won't overwrite the alias if defined
function alias_if_undefined() { 
    alias $1 &> /dev/null || alias $1=$2
}

# Push and pop directories on directory stack
alias_if_undefined pu 'pushd'
alias_if_undefined po 'popd'

# Basic directory operations
alias_if_undefined ... 'cd ../..'
alias_if_undefined -- 'cd -'

# Super user
alias_if_undefined _ 'sudo'

#alias_if_undefined g 'grep -in'

# Show history
alias_if_undefined history 'fc -l 1'

# List direcory contents
alias_if_undefined lsa 'ls -lah'
alias_if_undefined l 'ls -la'
alias_if_undefined ll 'ls -l'
alias_if_undefined sl 'ls' # often screw this up

alias_if_undefined afind 'ack-grep -il'

alias_if_undefined x 'extract'
