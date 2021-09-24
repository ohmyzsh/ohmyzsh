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
alias rrun="ruby -run -e"
alias rserver="ruby -run -e httpd . -p 8080" # requires webrick
