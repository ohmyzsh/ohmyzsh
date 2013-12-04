# The export line may need to be commented out in the .zshrc file
# as MacPorts adds this line when it finished install 
# Add MacPorts to PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# Aliases
alias pc="sudo port clean --all installed"
alias pi="sudo port install $1"
alias psu="sudo port selfupdate"
alias puni="sudo port uninstall inactive"
alias puo="sudo port upgrade outdated"
alias pup="psu && puo"

