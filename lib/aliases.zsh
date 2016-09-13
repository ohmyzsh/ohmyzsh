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
if [ "$HIST_STAMPS" = "mm/dd/yyyy" ]
then
    alias history='fc -fl 1'
elif [ "$HIST_STAMPS" = "dd.mm.yyyy" ]
then
    alias history='fc -El 1'
elif [ "$HIST_STAMPS" = "yyyy-mm-dd" ]
then
    alias history='fc -il 1'
else
    alias history='fc -l 1'
fi
# List direcory contents
alias lsa='ls -lah'
alias l='ls -la'
alias ll='ls -l'
alias la='ls -lA'
alias sl=ls # often screw this up

alias afind='ack-grep -il'

# iOS Simulator
alias ios='open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app'

# Code Directory
<<<<<<< HEAD
<<<<<<< HEAD
alias code='~/Dropbox/Code'

# SSHuttle
alias tunnel='sshuttle -D --pidfile=/tmp/sshuttle.pid -r abiggs@10.26.0.80 10.26.196.0/24'
alias stoptunnel='[[ -f /tmp/sshuttle.pid ]] && kill `cat /tmp/sshuttle.pid`'
<<<<<<< HEAD
=======
alias code='~/Dropbox\ \(Univ.\ of\ Oklahoma\)/Code'
<<<<<<< HEAD
alias wdrop='~/Dropbox\ \(Univ.\ of\ Oklahoma\)'
alias pdrop='~/Dropbox\ \(Personal\)'
>>>>>>> Add Dropbox aliases
=======
alias dw='~/Dropbox\ \(Univ.\ of\ Oklahoma\)'
=======
alias code='~/Dropbox/Code'
=======

# Dropbox
>>>>>>> Add find and remove conflicted Dropbox files alias
alias dw='~/Dropbox'
>>>>>>> Updated Dropbox aliases with new softlinks
alias dp='~/Dropbox\ \(Personal\)'
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> Changed Dropbox aliases
=======
=======
alias dpfc='find . -type f -name "* conflicted *"'
alias dprc='find . -type f -name "* conflicted *" -exec rm -f {} \;'
>>>>>>> Add find and remove conflicted Dropbox files alias

<<<<<<< HEAD
# Docker
<<<<<<< HEAD
alias dockup="boot2docker init && boot2docker up && eval \"\$(boot2docker shellinit)\""
>>>>>>> Add Boot2Docker alias.
=======
alias dockup="docker-machine create --driver virtualbox dev && eval \"\$(docker-machine env dev)\""
>>>>>>> Update dockup alias for Docker Machine
=======
# Docker Machine
alias dminit="docker-machine create --driver virtualbox default"
alias dmup="docker-machine start default; eval \"\$(docker-machine env default)\""
alias dmdown="docker-machine stop"
alias dm="docker-machine"
<<<<<<< HEAD
>>>>>>> Added Docker Machine aliases.
=======

# Docker Compose
alias dc="docker-compose"
alias dcup="docker-compose up -d"
alias dcdown="docker-compose stop"
alias dcrm="docker-compose stop && docker-compose rm -f"
<<<<<<< HEAD
>>>>>>> Add Docker Compose aliases.
=======

# Setup Docker Development Environment
alias devup="docker-compose -f ~/Dropbox/Code/docker/development/docker-compose.yml up -d"

# Enter Docker containers
alias devweb="docker exec -it web bash"
alias devdb="docker exec -it db bash"

# SSH
alias casapps="ssh 10.26.0.80"
alias casdb="ssh 10.26.192.133"
>>>>>>> Add SSH aliases
