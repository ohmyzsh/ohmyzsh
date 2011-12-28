# Aliases
alias et='mate .'
alias ett='mate app config lib db public spec test Rakefile Capfile Todo'
alias etp='mate app config features lib db public spec test Gemfile Rakefile Capfile Todo'
alias etts='mate app config lib db public script spec test vendor/plugins vendor/gems Rakefile Capfile Todo'

# Edit Ruby app in TextMate.
alias mr='mate CHANGELOG app config db lib public script spec test'

# Functions
function tm() {
  if [[ -z "$1" ]]; then
    mate .
  else
    ( [[ -d "$1" ]] && cd "$1" && mate . )
  fi
}

