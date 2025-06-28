function spackenv_prompt_info(){
  [[ -n ${SPACK_ENV} ]] || return
  export SPACK_ENV_PROMPT=$( basename $SPACK_ENV )
  echo "${ZSH_THEME_SPACKENV_PREFIX=(}${SPACK_ENV:t:gs/%/%%}${ZSH_THEME_SPACKENV_SUFFIX=)}"
}
