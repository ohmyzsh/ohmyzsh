source_env() {
  if [[ -f $ZSH_DOTENV_FILE ]]; then
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
