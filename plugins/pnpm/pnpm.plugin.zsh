if type compdef &>/dev/null; then
  _pnpm_completion () {
    local reply
    local si=$IFS

    IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" pnpm completion -- "${words[@]}"))
    IFS=$si

    if [ "$reply" = "__tabtab_complete_files__" ]; then
      _files
    else
      _describe 'values' reply
    fi
  }
  compdef _pnpm_completion pnpm
fi

# Run pnpm install
alias pnI="pnpm install"

 Install dependencies globally
alias pnga="pnpm add -g "

# pnpm package names are lowercase
# Thus, we've used camelCase for the following aliases:

# Install and save to dependencies in your package.json
# pnpm is used by https://pnpm.io/cli/add
alias pnA="pnpm add "

# Install and save to dev-dependencies in your package.json
# pnpm is used by https://pnpm.io/cli/add
alias pnD="pnpm add -D "

# Force npm to fetch remote resources even if a local copy exists on disk.
alias pnF='pnpm add -f'

# Check which pnpm modules are outdated
alias pnO="pnpm outdated"

# Update all the packages listed to the latest version
alias pnU="pnpm up"

# Check package versions
alias pnV="pnpm -v"

# List packages
alias pnL="pnpm list"

# List top-level installed packages
# Revisar
alias pnL0="pnpm ls --depth=0"

# Run pnpm start
alias pnst="pnpm start"

# Run pnpm test
alias pnt="pnpm test"

# Run pnpm scripts
alias pnR="pnpm run"

# Run pnpm init
alias pnIn="pnpm init"

# Run pnpm info
alias pni="pnpm info"

# Run pnpm publish
alias pni="pnpm publish"

# Run pnpm search
alias pnSe="pnpm search"

# Run pnpm run dev
alias pnd="pnpm run dev"

