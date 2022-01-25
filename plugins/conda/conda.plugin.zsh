function conda_prompt_info(){
  [[ -n ${CONDA_DEFAULT_ENV} ]] || return
  echo "${ZSH_THEME_CONDA_PREFIX=[}${CONDA_DEFAULT_ENV:t:gs/%/%%}${ZSH_THEME_CONDA_SUFFIX=]}"
}

# disables display (${CONDA_DEFAULT_ENV})
export CONDA_CHANGEPS1=false
