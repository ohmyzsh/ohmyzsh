<<<<<<< HEAD
# TODO: Make this compatible with rvm.
#       Run sudo gem on the system ruby, not the active ruby.
=======
# Run sudo gem on the system ruby, not the active ruby
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
alias sgem='sudo gem'

# Find ruby file
alias rfind='find . -name "*.rb" | xargs grep -n'
<<<<<<< HEAD
=======

# Shorthand Ruby
alias rb="ruby"

# Gem Command Shorthands
alias gein="gem install"
alias geun="gem uninstall"
alias geli="gem list"
alias gei="gem info"
alias geiall="gem info --all"
alias geca="gem cert --add"
alias gecr="gem cert --remove"
alias gecb="gem cert --build"
alias geclup="gem cleanup -n"
alias gegi="gem generate_index"
alias geh="gem help"
alias gel="gem lock"
alias geo="gem open"
alias geoe="gem open -e"
alias rrun="ruby -e"
alias rserver="ruby -e httpd . -p 8080" # requires webrick
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
