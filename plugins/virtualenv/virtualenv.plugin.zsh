function virtualenv_prompt_info(){
  [[ -n ${VIRTUAL_ENV} ]] || return
  # Some versions of virtualenv (e.g the version bundled with 'uv') wrap the
  # prompt in parentheses with a trailing space.
  local venv_prompt="${(*)VIRTUAL_ENV_PROMPT:/#%(#b)\((*)\) /${match[1]}}"

  if [ -z ${venv_prompt} ]; then
    # Older versions of virtualenv do not set VIRTUAL_ENV_PROMPT, so fall back
    # to the basename of the virtualenv path.
    venv_prompt="${VIRTUAL_ENV:t}"
  fi

  echo "${ZSH_THEME_VIRTUALENV_PREFIX=[}${venv_prompt:gs/%/%%}${ZSH_THEME_VIRTUALENV_SUFFIX=]}"
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1
