# Changing/making/removing directory
# Example of using an alias to automate the creation of a basic
# environment as follows:
# alias -g makestuff='mkdir dev; touch dev/app.js dev/index.html dev/style.css; cd dev; subl . '
# The -g means 'global'; so this will work while located in any directory.
# 'makestuff' is the alias; meaning if you type makestuff into zsh, the rest of the
# code is executed.
# Everything within the ' ' is what we want executed. If you're unsure of the syntax, feel free
# to test some things out in the terminal, as the syntax is the same. Happy customizing! 
# Also feel free to uncomment (delete #) on the makestuff alias and see how it works for you.
# Note: the subl . at the end is to open sublime. That will have to be changed to open the text editor
# of your preference if you're not on sublime.
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir
alias d='dirs -v | head -10'

# List directory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
