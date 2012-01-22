# Vi Editing and Sourcing aliases
alias ea='vi ~/.env/os/Linux/alias.sh'
alias eas='. ~/.env/os/Linux/alias.sh'
alias ees='. ~/.env/source.sh'
alias ef='vi ~/.env/os/Linux/functions.sh'
alias efs='. ~/.env/os/Linux/functions.sh'
alias ep='vi ~/.env/os/Linux/path.sh'
alias eps='. ~/.env/os/Linux/path.sh'
alias eh="vi ~/.env/host/$HOSTNAME/*.sh"
alias ehs=". ~/.env/host/$HOSTNAME/*.sh"

# Directory Listing aliases
alias dir='ls -hFx'
alias l.='ls -d .* --color=auto'
alias l='ls -lathF --color=auto'
alias L='ls -latrhF'
alias ll='ls -lFh'
alias lo='ls -laSFh'
alias vdir='ls --color=auto --format=long'

# Process Find Aliases
alias pfn='ps -e -o user,pid,args|grep'
