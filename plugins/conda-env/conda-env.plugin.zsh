function conda_prompt_info(){
  [[ -n ${CONDA_DEFAULT_ENV} ]] || return
  echo "${ZSH_THEME_CONDA_PREFIX=[}${CONDA_DEFAULT_ENV:t:gs/%/%%}${ZSH_THEME_CONDA_SUFFIX=]}"
}

# Has the same effect as `conda config --set changeps1 false`
# - https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#determining-your-current-environment
# - https://conda.io/projects/conda/en/latest/user-guide/configuration/use-condarc.html#precedence
export CONDA_CHANGEPS1=false
