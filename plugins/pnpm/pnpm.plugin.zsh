(( $+commands[pnpm] )) && {
  command rm -f "${ZSH_CACHE_DIR:-$ZSH/cache}/pnpm_completion"

  _pnpm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 pnpm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _pnpm_completion pnpm
}

# Install dependencies globally
alias pnpmg="pnpm add -g "

# pnpm package names are lowercase
# Thus, we've used camelCase for the following aliases:

# Install and save to dependencies in your package.json
alias pnpmS="pnpm add -S "

# Install and save to dev-dependencies in your package.json
alias pnpmD="pnpm add -D "

# Force pnpm to fetch remote resources even if a local copy exists on disk.
alias pnpmF='pnpm add -f'

# Execute command from node_modules folder based on current directory
# i.e pnpmE gulp
alias pnpmE='PATH="$(pnpm bin)":"$PATH"'

# Check which pnpm modules are outdated
alias pnpmO="pnpm outdated"

# Update all the packages listed to the latest version
alias pnpmU="pnpm update"

# Check package versions
alias pnpmV="pnpm -v"

# List packages
alias pnpmL="pnpm list"

# List top-level installed packages
alias pnpmL0="pnpm ls --depth=0"

# Run pnpm start
alias pnpmst="pnpm start"

# Run pnpm test
alias pnpmt="pnpm test"

# Run pnpm scripts
alias pnpmR="pnpm run"

# Run pnpm publish
alias pnpmP="pnpm publish"

# Run pnpm init
alias pnpmI="pnpm init"

# Run pnpm info
alias pnpmi="pnpm info"

# Run pnpm search
alias pnpmSe="pnpm search"

# Run pnpm run dev
alias pnpmrd="pnpm run dev"

# Run pnpm run build
alias pnpmrb="pnpm run build"

pnpm_toggle_install_uninstall() {
  # Look up to the previous 2 history commands
  local line
  for line in "$BUFFER" \
    "${history[$((HISTCMD-1))]}" \
    "${history[$((HISTCMD-2))]}"
  do
    case "$line" in
      "pnpm uninstall"*)
        BUFFER="${line/pnpm uninstall/pnpm install}"
        (( CURSOR = CURSOR + 2 )) # uninstall -> install: 2 chars removed
        ;;
      "pnpm install"*)
        BUFFER="${line/pnpm install/pnpm uninstall}"
        (( CURSOR = CURSOR + 2 )) # install -> uninstall: 2 chars added
        ;;
      "pnpm remove"*)
        BUFFER="${line/pnpm remove/pnpm add}"
        (( CURSOR = CURSOR + 5 )) # remove -> add: 5 chars removed
        ;;
      "pnpm add"*)
        BUFFER="${line/pnpm add/pnpm remove}"
        (( CURSOR = CURSOR + 2 )) # add -> remove: 2 chars added
        ;;
      "pnpm un "*)
        BUFFER="${line/pnpm un/pnpm add}"
        (( CURSOR = CURSOR + 5 )) # un -> add: 5 chars added
        ;;
      "pnpm i "*)
        BUFFER="${line/pnpm i/pnpm remove}"
        (( CURSOR = CURSOR + 8 )) # i -> remove: 8 chars added
        ;;
      *) continue ;;
    esac
    return 0
  done

  BUFFER="pnpm install"
  CURSOR=${#BUFFER}
}

zle -N pnpm_toggle_install_uninstall

# Defined shortcut keys: [F2] [F2]
bindkey -M emacs '^[OQ^[OQ' pnpm_toggle_install_uninstall
bindkey -M vicmd '^[OQ^[OQ' pnpm_toggle_install_uninstall
bindkey -M viins '^[OQ^[OQ' pnpm_toggle_install_uninstall
