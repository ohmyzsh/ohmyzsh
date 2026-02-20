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

_MOLECULE_COMPLETE=zsh_source molecule >| "$ZSH_CACHE_DIR/completions/_molecule" &|

# Alias
# molecule: https://docs.ansible.com/projects/molecule/
alias mol='molecule '
alias mhlp='molecule --help '
alias mchk='molecule check '
alias mcln='molecule cleanup '
alias mcnv='molecule converge '
alias mcrt='molecule create '
alias mdep='molecule dependency '
alias mdes='molecule destroy '
alias mdrv='molecule drivers '
alias midm='molecule idempotence '
alias minit='molecule init scenario '
alias mlst='molecule list '
alias mlgn='molecule login '
alias mtrx='molecule matrix '
alias mprp='molecule prepare '
alias mrst='molecule reset '
alias msef='molecule side-effect '
alias msyn='molecule syntax '
alias mtest='molecule test '
alias mvrf='molecule verify '
