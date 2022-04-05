function conda_prompt_info(){
  if command -v pyenv &>/dev/null && [[ $plugins == *"virtualenv"* ]]; then
    return
  else
    [[ -n ${CONDA_DEFAULT_ENV} ]] || return
    echo "${ZSH_THEME_CONDA_PREFIX=[}${CONDA_DEFAULT_ENV:t:gs/%/%%}${ZSH_THEME_CONDA_SUFFIX=]}"
  fi
}

# disables display (${CONDA_DEFAULT_ENV})
export CONDA_CHANGEPS1=false

