# Add yourself some shortcuts to projects you often work on
# Example:
#
# brainstormr=/Users/robbyrussell/Projects/development/planetargon/brainstormr
#
alias p='tail -1 /home/pdavis/notes.txt | pbcopy'
alias pbcopy='xsel --clipboard --input'
alias rosh='ssh pdavis-admin@opsware.discovery.com -p 2222'
alias console='cu -t -l /dev/ttyUSB0 -s 115200'
<<<<<<< HEAD
alias open='ssh $1 -l pdavis-admin'
alias home='ssh netinstall@pebcac.org'
alias myrouter='ssh tunnel@192.168.10.1'
alias coreswitch='ssh tunnel@192.168.10.3'
alias pswitch='ssh tunnel@192.168.10.4'
alias jumphost='ssh pdavis@jumphost.pebcac.org'

# Start with tmux
=======
alias open='ssh $1 -l pdavis-admin' 
>>>>>>> c0134a9450e486251b247735e022d7efeb496b9c
[[ $TERM != "screen" ]] && exec tmux
