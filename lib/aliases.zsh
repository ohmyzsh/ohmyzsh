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
if [ "$HIST_STAMPS" = "mm/dd/yyyy" ]
then
    alias history='fc -fl 1'
elif [ "$HIST_STAMPS" = "dd.mm.yyyy" ]
then
    alias history='fc -El 1'
elif [ "$HIST_STAMPS" = "yyyy-mm-dd" ]
then
    alias history='fc -il 1'
else
    alias history='fc -l 1'
fi
# List direcory contents
alias lsa='ls -lah'
alias l='ls -la'
#alias ll='ls -l'
alias sl=ls # often screw this up
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

alias afind='ack-grep -il'

# DD: mine, or added from https://github.com/thoughtbot/dotfiles

# Folder aliases
alias ls='ls -F'
alias la='la -A'
alias ll='ls -lA'
alias ..='cd ..'
alias ...='../..'
alias path='echo -e ${PATH//:/\\\n}'

# Ruby aliases
alias rss='ruby script/server'
alias rssd='ruby script/server -u'
alias rsc='ruby script/console'

# Gem/Rails aliases
alias geml='gem list --local | more'
alias geme='cd `rvm gemdir`/gems; ls'
alias cap='bundle exec cap'
alias rake='bundle exec rake'
#alias migrate="rake db:migrate db:test:prepare"
#alias remigrate="rake db:migrate && rake db:migrate:redo && rake db:schema:dump db:test:prepare"
#alias remongrate="rake mongoid:migrate && rake mongoid:migrate:redo"

# POW aliases
alias p='powder'

# Git aliases
alias g="git"
alias glog='git log --color'
alias gd='git diff --color'
alias gs='git status'
alias gcom='git commit'
alias gpu='git pull'
alias gps='git push'
alias gcm='git checkout master'
alias gcp='git checkout production'
alias gch='git checkout'
alias gmm='git merge master'
#alias gci="git pull --rebase && rake && git push"
alias tlf="tail -f"

alias ln='ln -v'
alias mkdir='mkdir -p'

alias -g G='| grep'
alias -g M='| less'
alias -g L='| wc -l'
alias -g ONE="| awk '{ print \$1}'"

# git
alias gci="git pull --rebase && rake && git push"

# Bundler
alias b="bundle"
alias be="bundle exec"
alias bake="bundle exec rake"

# Tests and Specs
alias t="ruby -I test"
alias s="bundle exec rspec"
alias cuc="bundle exec cucumber"

# Rubygems
alias gi="gem install"
alias giv="gem install -v"

# Network
alias whats-my-ip="curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+'"

# Annoyances
alias heroku='nocorrect heroku'
alias h='heroku'
alias jitsu='nocorrect jitsu'
alias guard='bundle exec guard'


