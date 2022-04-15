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
<<<<<<< HEAD
alias l='ls -la'
alias ll='ls -l'
alias la='ls -lA'
=======
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
>>>>>>> ff9b127138000626b9a6699b8f5e05e884c3b445
alias sl=ls # often screw this up

alias afind='ack-grep -il'

# iOS Simulator
alias ios='open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app'

# Code Directory
<<<<<<< HEAD
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
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
alias dbw='~/Dropbox'
alias dbp='~/Dropbox\ \(Personal\)'
alias dbfc='find . -type f -name "* conflicted *"'
alias dbrc='find . -type f -name "* conflicted *" -exec rm -f {} \;'
>>>>>>> Fix Dropbox aliases
=======
alias db='~/Dropbox'
alias dbfc='find ~"/Dropbox (Univ. of Oklahoma)" -type f -name "* conflicted *"'
alias dbrc='find ~"/Dropbox (Univ. of Oklahoma)" -type f -name "* conflicted *" -exec rm -f {} \;'
>>>>>>> Update Dropbox conflict alias

<<<<<<< HEAD
# Docker
<<<<<<< HEAD
alias dockup="boot2docker init && boot2docker up && eval \"\$(boot2docker shellinit)\""
>>>>>>> Add Boot2Docker alias.
=======
alias dockup="docker-machine create --driver virtualbox dev && eval \"\$(docker-machine env dev)\""
>>>>>>> Update dockup alias for Docker Machine
=======
=======
alias code='~/Dropbox/Code'

# SSHuttle
# alias tunnel='sshuttle -D --pidfile=/tmp/sshuttle.pid -r abiggs@10.26.0.80 10.26.196.0/24'
# alias stoptunnel='[[ -f /tmp/sshuttle.pid ]] && kill `cat /tmp/sshuttle.pid`'
alias tunnel='sshuttle -D --dns --pidfile=/tmp/sshuttle.pid -r abiggs@192.168.1.115 0/0'
alias stoptunnel='[[ -f /tmp/sshuttle.pid ]] && kill `cat /tmp/sshuttle.pid`'

# Dropbox
alias db='~/Dropbox'
alias dbfc='find ~"/Dropbox (Univ. of Oklahoma)" -type f -name "* conflicted *"'
alias dbrc='find ~"/Dropbox (Univ. of Oklahoma)" -type f -name "* conflicted *" -exec rm -f {} \;'

>>>>>>> ff9b127138000626b9a6699b8f5e05e884c3b445
# Docker Machine
alias dminit="docker-machine create --driver virtualbox default"
alias dmup="docker-machine start default; eval \"\$(docker-machine env default)\""
alias dmdown="docker-machine stop"
alias dm="docker-machine"
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> Added Docker Machine aliases.
=======
=======
>>>>>>> ff9b127138000626b9a6699b8f5e05e884c3b445

# Docker Compose
alias dc="docker-compose"
alias dcup="docker-compose up -d"
alias dcdown="docker-compose stop"
alias dcrm="docker-compose stop && docker-compose rm -f"
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> Add Docker Compose aliases.
=======
=======
>>>>>>> ff9b127138000626b9a6699b8f5e05e884c3b445

# Setup Docker Test Environment
alias devup="docker-compose -f ~/Dropbox/Code/docker/test/docker-compose.yml up -d"
alias devdown="docker-compose -f ~/Dropbox/Code/docker/test/docker-compose.yml stop"

# Enter Docker containers
alias devweb="docker exec -it web bash"
alias devdb="docker exec -it db bash"

# SSH
alias casapps="ssh 10.26.0.80"
alias casdb="ssh 10.26.192.133"
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> Add SSH aliases
=======
alias casappsdev="ssh 10.26.0.230"
alias casdbdev="ssh 10.26.192.193"
>>>>>>> Update Docker and SSH aliases
=======
alias casappsdev="ssh 10.26.0.230"
alias casdbdev="ssh 10.26.192.193"
>>>>>>> ff9b127138000626b9a6699b8f5e05e884c3b445
