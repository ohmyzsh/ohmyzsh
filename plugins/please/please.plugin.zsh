# Auto completion for plz, the command line tool for the please build system
# For more details go to http://please.build
#
# Author: https://github.com/thought-machine

if [ $commands[plz] ]; then
    source <(plz --completion_script)
fi

alias pb='plz build'
alias pt='plz test'
alias pw='plz watch'
