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
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias sl=ls # often screw this up

alias afind='ack-grep -il'

# iOS Simulator
alias ios='open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app'

# Code Directory
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

# Docker Machine
alias dminit="docker-machine create --driver virtualbox default"
alias dmup="docker-machine start default; eval \"\$(docker-machine env default)\""
alias dmdown="docker-machine stop"
alias dm="docker-machine"

# Docker Compose
alias dc="docker-compose"
alias dcup="docker-compose up -d"
alias dcdown="docker-compose stop"
alias dcrm="docker-compose stop && docker-compose rm -f"

# Setup Docker Test Environment
alias devup="docker-compose -f ~/Dropbox/Code/docker/test/docker-compose.yml up -d"
alias devdown="docker-compose -f ~/Dropbox/Code/docker/test/docker-compose.yml stop"

# Enter Docker containers
alias devweb="docker exec -it web bash"
alias devdb="docker exec -it db bash"

# SSH
alias casapps="ssh 10.26.0.80"
alias casdb="ssh 10.26.192.133"
alias casappsdev="ssh 10.26.0.230"
alias casdbdev="ssh 10.26.192.193"
