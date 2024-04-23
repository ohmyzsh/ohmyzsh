# Check if the user has configured Yarn Berry
is_yarn_berry="false"
if zstyle -t ':omz:plugins:yarn' berry; then
  is_yarn_berry="true"
fi

if zstyle -T ':omz:plugins:yarn' global-path; then
  # Skip yarn call if default global bin dir exists
  [[ -d "$HOME/.yarn/bin" ]] && bindir="$HOME/.yarn/bin" || bindir="$(yarn global bin 2>/dev/null)"

  # Add yarn bin directory to $PATH if it exists and not already in $PATH
  [[ $? -eq 0 ]] \
    && [[ -d "$bindir" ]] \
    && (( ! ${path[(Ie)$bindir]} )) \
    && path+=("$bindir")
  unset bindir
fi

alias y="yarn"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yap="yarn add --peer"
alias yb="yarn build"
alias ycc="yarn cache clean"
alias yd="yarn dev"
alias yf="yarn format"
alias yh="yarn help"
alias yi="yarn init"
alias yin="yarn install"
alias yln="yarn lint"
alias ylnf="yarn lint --fix"
alias yp="yarn pack"
alias yrm="yarn remove"
alias yrun="yarn run"
alias ys="yarn serve"
alias yst="yarn start"
alias yt="yarn test"
alias ytc="yarn test --coverage"
alias yui="yarn upgrade-interactive"

# --latest flag was removed in yarn berry so we execute the base command
if [[ ${is_yarn_berry} == "true" ]]; then
  alias yuil='yui'
else
  alias yuil='yarn upgrade-interactive --latest'
fi

# The flag for installing with restrictive lockfile was changed in yarn berry
if [[ ${is_yarn_berry} == "true" ]]; then
  alias yii='yarn install --immutable'
else
  alias yii='yarn install --frozen-lockfile'
fi

alias yifl="yii"
alias yup="yarn upgrade"
alias yv="yarn version"
alias yw="yarn workspace"
alias yws="yarn workspaces"
alias yy="yarn why"

# Commands that are specific to the yarn version being used
if [[ ${is_yarn_berry} == "true" ]]; then
  alias ydlx="yarn dlx"
  alias yn="yarn node"
else
  alias yga="yarn global add"
  alias ygls="yarn global list"
  alias ygrm="yarn global remove"
  alias ygu="yarn global upgrade"
  alias yls="yarn list"
  alias yout="yarn outdated"
  alias yuca="yarn global upgrade && yarn cache clean"
fi

unset is_yarn_berry
