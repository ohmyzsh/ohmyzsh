#Aliases
alias pc="sudo port clean --all installed"
alias pi="sudo port install $1"
alias psync="sudo port sync"
alias psu="sudo port selfupdate"
alias puni="sudo port -u uninstall inactive"
alias puo="sudo port -u upgrade outdated"
alias pup="psu && puo"

