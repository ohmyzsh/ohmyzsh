# Yay! High voltage and arrows!


function _virtualenv_prompt_info {
    if [[ -n "$(whence virtualenv_prompt_info)" ]]; then
        if [ -n "$(whence pyenv_prompt_info)" ]; then
            if [ "$1" = "inline" ]; then
                ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=%F{blue}"::%F{red}"
                ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX=""
                virtualenv_prompt_info
            fi
            [ "$(pyenv_prompt_info)" = "${PYENV_PROMPT_DEFAULT_VERSION}" ] && virtualenv_prompt_info
        else
            virtualenv_prompt_info
        fi
    fi
}

prompt_setup_pygmalion(){
  setopt localoptions extendedglob

  ZSH_THEME_GIT_PROMPT_PREFIX="%f%F{green}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
  ZSH_THEME_GIT_PROMPT_DIRTY="%F{yellow}⚡%f"
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  base_prompt='$(_virtualenv_prompt_info)%F{magenta}%n%f%F{cyan}@%f%F{yellow}%m%f%F{red}:%f%F{cyan}%0~%f%F{red}|%f'
  post_prompt='%F{cyan}⇒%f  '

  base_prompt_nocolor=${base_prompt//\%\{[^\}]##\}}
  post_prompt_nocolor=${post_prompt//\%\{[^\}]##\}}

  autoload -U add-zsh-hook
  add-zsh-hook precmd prompt_pygmalion_precmd
}

prompt_pygmalion_precmd(){
  setopt localoptions nopromptsubst extendedglob

  local gitinfo=$(git_prompt_info)
  local gitinfo_nocolor=${gitinfo//\%\{[^\}]##\}}
  local exp_nocolor="$(print -P \"${base_prompt_nocolor}${gitinfo_nocolor}${post_prompt_nocolor}\")"
  local prompt_length=${#exp_nocolor}

  # add new line on prompt longer than 40 characters
  local nl=""
  if [[ $prompt_length -gt 40 ]]; then
    nl=$'\n%{\r%}'
  fi

  PROMPT="${base_prompt}\$(git_prompt_info)${nl}${post_prompt}"
}

prompt_setup_pygmalion
