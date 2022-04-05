function virtualenv_prompt_info(){
  [[ -n ${VIRTUAL_ENV} ]] || return
<<<<<<< HEAD
  echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
=======
  echo "${ZSH_THEME_VIRTUALENV_PREFIX=[}${VIRTUAL_ENV:t:gs/%/%%}${ZSH_THEME_VIRTUALENV_SUFFIX=]}"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1
