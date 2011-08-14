# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Basic directory operations
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'

#alias g='grep -in'

# Show history
alias history='fc -l 1'

# List direcory contents
alias lsa='ls -lah'
alias l='ls -la'
alias ll='ls -l'
alias sl=ls # often screw this up

alias afind='ack-grep -il'

alias x=extract
alias reload="source ~/.zshrc"
alias galias='alias | grep'

# Request confirmation before attempting to remove each file, regardless of the file's permissions, or
# whether or not the standard input device is a terminal.  The -i option overrides any previous -f options.
alias rm="rm -i"

alias psg='show_processes'
