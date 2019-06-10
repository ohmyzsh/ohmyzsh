function alias-find(){
    alias | grep $1
}

alias af="alias-find "

##kubectl alias
alias kls="kcgc"
alias kcd="kcuc"

## macos 
function lock(){
    /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
}

alias lk="lock"