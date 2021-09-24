# TODO: Make this compatible with rvm.
#       Run sudo gem on the system ruby, not the active ruby.
alias sgem='sudo gem'

# Find ruby file
alias rfind='find . -name "*.rb" | xargs grep -n'

# Shorthand Ruby
alias rb="ruby"

# Run Ruby code on command line
alias rrun='ruby -run -e'

# Start local server
alias rbserver='ruby -run -e httpd'

# Gem Command Shorthands
alias gin="gem install"
alias gun="gem uninstall"
alias gli="gem list"
