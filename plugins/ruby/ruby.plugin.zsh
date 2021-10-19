# TODO: Make this compatible with rvm.
#       Run sudo gem on the system ruby, not the active ruby.
alias sgem='sudo gem'

# Find ruby file
alias rfind='find . -name "*.rb" | xargs grep -n'

# Shorthand Ruby
alias rb="ruby"

# Gem Command Shorthands
alias gin="gem install"
alias gun="gem uninstall"
alias gli="gem list"
alias gi="gem info"
alias giall="gem info --all"
alias gca="gem cert --add"
alias gcr="gem cert --remove"
alias gcb="gem cert --build"
alias gclup="gem cleanup -n"
alias ggi="gem generate_index"
alias gh="gem help"
alias gl="gem lock"
alias go="gem open"
alias goe="gem open -e"
