unalias cna cnrn 2>/dev/null
cna()  { conda activate "$@"; }
cnrn() { conda remove -y --all -n "$@"; }

alias cnab='conda activate base'
alias cncf='conda env create -f'
alias cncn='conda create -y -n'
alias cnconf='conda config'
alias cncp='conda create -y -p'
alias cncr='conda create -n'
alias cncss='conda config --show-source'
alias cnde='conda deactivate'
alias cnel='conda env list'
alias cni='conda install'
alias cniy='conda install -y'
alias cnl='conda list'
alias cnle='conda list --export'
alias cnles='conda list --explicit > spec-file.txt'
alias cnr='conda remove'
alias cnrp='conda remove -y --all -p'
alias cnry='conda remove -y'
alias cnsr='conda search'
alias cnu='conda update'
alias cnua='conda update --all'
alias cnuc='conda update conda'

_omz_conda_envs() {
  emulate -L zsh -o extended_glob
  local envs_file="$HOME/.conda/environments.txt"
  [[ -r "$envs_file" ]] || return 1

  # Each line is an env prefix; named envs live under <dir>/envs/<name>.
  # The root prefix (base) and envs created with -p have no name and are skipped.
  local -aU envs
  envs=(${(f)"$(<$envs_file)"})
  envs=(${${(M)envs:#*/envs/[^/]##}:t})
  (( ${#envs} )) && compadd -Q -a envs
}

if (( $+functions[compdef] )); then
  compdef _omz_conda_envs cna cnrn
fi
