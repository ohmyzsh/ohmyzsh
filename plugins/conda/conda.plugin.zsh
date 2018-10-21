# Aliases
alias cac="source activate"
alias cup="conda update"
alias csr="conda search"
alias cin="conda install"
alias crm="conda remove"
alias ccr="conda create -n"

# Functions
function conda_prompt_info(){
  [[ -n ${CONDA_DEFAULT_ENV} ]] || return
  echo "${ZSH_THEME_CONDA_PREFIX:=[}${CONDA_DEFAULT_ENV:t}${ZSH_THEME_CONDA_SUFFIX:=]}"
}
