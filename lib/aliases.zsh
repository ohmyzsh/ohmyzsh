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
alias code='~/Dropbox/Code'

# SSHuttle
alias tunnel='sshuttle -D --pidfile=/tmp/sshuttle.pid -r abiggs@10.26.0.80 10.26.196.0/24'
alias stoptunnel='[[ -f /tmp/sshuttle.pid ]] && kill `cat /tmp/sshuttle.pid`'
=======
alias code='~/Dropbox\ \(Univ.\ of\ Oklahoma\)/Code'
<<<<<<< HEAD
alias wdrop='~/Dropbox\ \(Univ.\ of\ Oklahoma\)'
alias pdrop='~/Dropbox\ \(Personal\)'
>>>>>>> Add Dropbox aliases
=======
alias dw='~/Dropbox\ \(Univ.\ of\ Oklahoma\)'
alias dp='~/Dropbox\ \(Personal\)'
>>>>>>> Changed Dropbox aliases
