# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Basic directory operations
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'

# Show line and ignore case with grep
alias g='grep -in'

# Show history
alias history='fc -l 1'

# Allways use vim
[[ -x $(which vim) ]] && alias vi='vim'

# Search for processes in ps
alias psgrep='ps aux | grep -v grep | grep'

# Open a SSH tunnel listening on localhost:8888
alias tunnel='ssh -fqND 8888'

# Python stuff
alias 2to3='2to3 -x buffer'
alias pydebug='python -m pudb.run'

# IPv6 netstat version
alias netstat6='netstat -A inet6'

# Search for connections in netstat
alias netgrep='netstat -lapute -np | grep'
alias netgrep6='netstat6 -lapute -np | grep'

# Limit ping to 3 requests
alias ping='ping -c 3'

# List direcory contents
alias l='ls -la'
alias ll='ls -l'
alias lh='ls -lAh'
alias sl=ls # often screw this up

# Search directory contents
alias lsgrep='lh | grep'

alias afind='ack-grep -il'
