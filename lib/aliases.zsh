# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Basic directory operations
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'
alias please='sudo'

#alias g='grep -in'

# Show history
alias history='fc -l 1'

# List direcory contents
alias lsa='ls -lah'
alias l='ls -lA1'
alias ll='ls -l'
alias la='ls -lA'
alias sl=ls # often screw this up

alias afind='ack-grep -il'

# Rails Pry
alias rpry="rails-console-pry -r pry-doc -r awesome_print"

# Go to specific folders that I need to go to
alias code="cd ~/Code/"
alias rkoans="cd /Users/tarebyte/Code/Languages/Ruby/ruby_koans/"
alias ckoans="cd /Users/tarebyte/Code/Languages/Clojure/clojure-koans"

# I'm pretty lazy
alias pingG="ping -c 4 8.8.8.8"
