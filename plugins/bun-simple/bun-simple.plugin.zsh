(( $+commands[bun] )) && {
  source <(SHELL=zsh bun completions 2>/dev/null)
}

# Install dependencies globally
alias bung="bun add -g "

# Install and save to dependencies in your package.json
alias bunA="bun add "

# Install and save to dev-dependencies in your package.json
alias bunD="bun add -d "

# Force bun to fetch remote resources even if a local copy exists on disk
alias bunF='bun i -f'

# Execute command from node_modules/.bin based on current directory
# i.e. bunE eslint
alias bunE='PATH="$(bun pm bin 2>/dev/null || '\
'printf "%s/node_modules/.bin" "$PWD")":"$PATH"'

# Check which dependencies are outdated
alias bunO="bun outdated"

# Update all the packages listed to the latest version
alias bunU="bun update"

# Check bun version
alias bunV="bun -v"

# List packages
alias bunL="bun pm ls --all"

# List top-level installed packages
alias bunL0="bun pm ls"

# Run bun start
alias bunst="bun start"

# Run bun test
alias bunt="bun test"

# Run bun scripts
alias bunR="bun run"

# Run bun publish
alias bunP="bun publish"

# Run bun init
alias bunI="bun init"

# Run bun info
alias buni="bun info"

# Note: bun does not provide a registry search command (no bunSe equivalent
# for npm search)

# Run bun run dev
alias bunrd="bun run dev"

# Run bun run build
alias bunrb="bun run build"
