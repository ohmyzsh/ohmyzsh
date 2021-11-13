# Add yarn bin directory to $PATH if it exists and not in $PATH already
bindir=$(yarn global bin 2>/dev/null) \
  && [[ -d "$bindir" ]] \
  && (( ! ${path[(Ie)$bindir]} )) \
  && path+=("$bindir")
unset bindir

alias y="yarn"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yap="yarn add --peer"
alias yb="yarn build"
alias ycc="yarn cache clean"
alias yd="yarn dev"
alias yga="yarn global add"
alias ygls="yarn global list"
alias ygrm="yarn global remove"
alias ygu="yarn global upgrade"
alias yh="yarn help"
alias yi="yarn init"
alias yin="yarn install"
alias yln="yarn lint"
alias ylnf="yarn lint --fix"
alias yls="yarn list"
alias yout="yarn outdated"
alias yp="yarn pack"
alias yrm="yarn remove"
alias yrun="yarn run"
alias ys="yarn serve"
alias yst="yarn start"
alias yt="yarn test"
alias ytc="yarn test --coverage"
alias yuc="yarn global upgrade && yarn cache clean"
alias yui="yarn upgrade-interactive"
alias yuil="yarn upgrade-interactive --latest"
alias yup="yarn upgrade"
alias yv="yarn version"
alias yw="yarn workspace"
alias yws="yarn workspaces"
