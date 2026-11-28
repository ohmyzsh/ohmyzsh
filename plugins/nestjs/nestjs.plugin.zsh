# Oh My Zsh plugin for NestJS CLI

# Check if nest command exists
if ! command -v nest &>/dev/null; then
  return
fi

# Project creation
alias nnew='nest new'

# Basic development
alias nb='nest build'
alias ns='nest start'
alias nsw='nest start --watch'
alias nsd='nest start --dev' # Alias for start --watch
alias nsdbg='nest start --debug --watch'

# Code generation (short aliases)
alias ng='nest generate'
alias ngm='nest generate module'
alias ngc='nest generate controller'
alias ngs='nest generate service'
alias ngg='nest generate guard'
alias ngp='nest generate pipe'
alias ngf='nest generate filter'
alias ngr='nest generate resolver'
alias ngcl='nest generate class'
alias ngi='nest generate interface'
alias ngit='nest generate interceptor'
alias ngmi='nest generate middleware'
alias ngd='nest generate decorator'
alias ngres='nest generate resource'
alias nglib='nest generate library'
alias ngsub='nest generate sub-app'

# Other commands
alias na='nest add'
alias ni='nest info'
alias nu='nest update'

# You can add more aliases or functions here as needed.
