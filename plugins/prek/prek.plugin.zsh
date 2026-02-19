# Prek plugin for Oh My Zsh
# Description: Adds aliases for prek, a faster drop-in replacement for pre-commit
# Author: Based on the pre-commit plugin structure
# Repository: https://github.com/j178/prek

# Main command
alias pk='prek'

# Installation & Setup
alias pki='prek install'
alias pkii='prek install --install-hooks'
alias pkih='prek install-hooks'

# Running Hooks
alias pkr='prek run'
alias pkra='prek run --all-files'
alias pkrf='prek run --files'
alias pkrl='prek run --last-commit'
alias pkrd='prek run --directory'

# Management
alias pku='prek uninstall'
alias pkl='prek list'

# Updates
alias pkau='prek auto-update'
alias pksu='prek self update'

# Configuration
alias pkvc='prek validate-config'
alias pkvm='prek validate-manifest'
alias pksc='prek sample-config'

# Cache Management
alias pkcd='prek cache dir'
alias pkcgc='prek cache gc'
alias pkcc='prek cache clean'
