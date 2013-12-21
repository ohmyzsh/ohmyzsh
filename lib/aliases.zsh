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
alias sl=ls # often screw this up
alias ls='gls --color=tty -hF'
alias ll='gls --color=tty -lhFa'
alias l='gls --color=tty -lhF'
alias ss='open -a /System/Library/Frameworks/ScreenSaver.framework//Versions/A/Resources/ScreenSaverEngine.app'
alias node="ssh rever@andrewfree.com"
alias irc="ssh -t root@andrewfree.com screen -r"
alias gfr="git fetch && git rebase remotes/origin/master"


alias afind='ack-grep -il'

# Open in textmate
alias o='subl $1'
alias zshconfig='subl ~/.zshrc'
alias ohmyzsh='subl ~/.oh-my-zsh'
alias ft='open -g /opt/local/bin/ft.app/' # Launch terminal window of top finder window
alias oo='open .'
alias rm='/opt/local/bin/MacRm'
alias rrm='/bin/rm'
alias bp='bpython-2.7'


alias ipx="curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
alias mnode="sshfs root@andrewfree.com:/ /Users/rever/nodessh/"
alias mtech="echo vjW5zWfXLMBDxnj9gJ7F | sshfs andrew@69.194.130.58:/home/andrew/ /Users/rever/techssh/"
alias audio_pause="sudo pkill -STOP coreaudiod"
alias audio_play="sudo pkill -CONT coreaudiod"
# defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 40
