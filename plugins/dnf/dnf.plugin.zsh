## Aliases for dnf - based on yum plugin


# Unprivileged

alias dnl="dnf list"
alias dnli="dnf list installed"
alias dns="dnf search"
alias dnp="dnf info"
alias dnc="dnf clean all"
alias dngl="dnf group list"


# Privileged
alias dni="$(if [[ $EUID -ne 0 ]]; then echo "sudo"; fi) dnf install"
alias dnu="$(if [[ $EUID -ne 0 ]]; then echo "sudo"; fi) dnf upgrade"
alias dnr="$(if [[ $EUID -ne 0 ]]; then echo "sudo"; fi) dnf remove"
alias dngi="$(if [[ $EUID -ne 0 ]]; then echo "sudo"; fi) dnf group install"
alias dngr="$(if [[ $EUID -ne 0 ]]; then echo "sudo"; fi) dnf group remove"
alias dngu="$(if [[ $EUID -ne 0 ]]; then echo "sudo"; fi) dnf group upgrade"
