# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Basic directory operations
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'
alias please='sudo'

#alias g='grep -in'

# Show history
alias history='fc -l 1'

# List direcory contents
alias lsa='ls -lah'
alias l='ls -lA1'
alias ll='ls -l'
alias la='ls -lA'
alias sl=ls # often screw this up

alias afind='ack-grep -il'

alias reload="source ~/.zshrc"
alias galias='alias | grep'

# Request confirmation before attempting to remove each file, regardless of the file's permissions, or
# whether or not the standard input device is a terminal.  The -i option overrides any previous -f options.
#alias rm="rm -i"

alias psg='show_processes'

# If you are using oh-my-zsh and you see something like this error:
# pwd:4: too many arguments
# This is caused by an alias and due to the sh style sourcing of a
# script using the '.' operator instead of 'source'.
# So, uncomment below line.
# alias .='pwd'

alias ssh-list='cat ~/.ssh/config'
