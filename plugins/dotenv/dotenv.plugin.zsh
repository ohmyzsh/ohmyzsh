source_env() {
  if [[ -f $ZSH_DOTENV_FILE ]]; then
    if [ "$ZSH_DOTENV_PROMPT" != "false" ]; then
      # confirm before sourcing file
      local confirmation
      # print same-line prompt and output newline character if necessary
      echo -n "dotenv: source '$ZSH_DOTENV_FILE' file in the directory? (Y/n) "
      read -k 1 confirmation; [[ "$confirmation" != $'\n' ]] && echo
      # only bail out if confirmation character is n
      if [[ "$confirmation" = [nN] ]]; then
        return
      fi
    fi

    # test .env syntax
    zsh -fn $ZSH_DOTENV_FILE || echo "dotenv: error when sourcing '$ZSH_DOTENV_FILE' file" >&2

    if [[ -o a ]]; then
      source $ZSH_DOTENV_FILE
    else
      set -a
      source $ZSH_DOTENV_FILE
      set +a
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env

if [[ -z $ZSH_DOTENV_FILE ]]; then
    ZSH_DOTENV_FILE=.env
fi

source_env
