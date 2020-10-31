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


prependToPath() {
	# Prepend a new directory to the path if it's not already in there
	local newpath="${1:?Need path to prepend}"

	# Return if already found in PATH
	if printf "%s" "$PATH" | grep -qE "(^|:)$newpath(:|$)"; then return; fi

	# Prepend to path
	export PATH="$newpath:$PATH"
}

# Add Yarn to path
prependToPath "$HOME/.config/yarn/global/node_modules/.bin"
prependToPath "$HOME/.yarn/bin"
