# ls
alias l="ls -FG"
alias ls="ls -FG"
alias la="l -lAh"

alias e="$EDITOR"

# git
alias g='git'
alias gl='git pull'
alias gp='git push'
alias gph='gp && gp heroku'
alias gd='git diff'
alias gc='git clone'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias gca='grm; git add .;gs;read;git commit'
alias git-authors='git shortlog -s -n'
# alias changelog='git log `git log -1 --format=%H -- CHANGELOG*`..; cat CHANGELOG*'
# alias gf='git flow'

# rails
alias r="rails"
alias tlog='tail -f log/development.log'
alias rst='touch tmp/restart.txt'
alias bi="bundle install"
alias bu="bundle update"
alias rake_db_migrate_both="rake db:migrate && rake db:migrate RAILS_ENV=test"


# commands starting with % for pasting from web
alias %=' '

alias sleepmac="osascript -e 'tell application \"System Events\" to sleep'"
