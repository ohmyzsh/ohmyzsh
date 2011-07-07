alias et='mate .'
alias ett='mate app config lib db public spec test Rakefile Capfile Todo'
alias etp='mate app config lib db public spec test vendor/plugins vendor/gems Rakefile Capfile Todo'
alias etts='mate app config lib db public script spec test vendor/plugins vendor/gems Rakefile Capfile Todo'

# Edit Ruby app in TextMate
alias mr='mate CHANGELOG app config db lib public script spec test'

function tm() {
  cd $1
  mate $1
}
