# Completion
if (( ! $+commands[molecule] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `molecule`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_molecule" ]]; then
  typeset -g -A _comps
  autoload -Uz _molecule
  _comps[molecule]=_molecule
fi

{
  local completion="$ZSH_CACHE_DIR/completions/_molecule" tmp
  tmp=$(command mktemp "$completion.XXXXXX") || exit
  _MOLECULE_COMPLETE=zsh_source molecule >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|

# Alias
# molecule: https://docs.ansible.com/projects/molecule/
alias mol='molecule'
alias mcr='molecule create'
alias mcon='molecule converge'
alias mls='molecule list'
alias mvf='molecule verify'
