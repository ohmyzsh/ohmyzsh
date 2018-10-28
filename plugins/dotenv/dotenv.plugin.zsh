source_env() {
  if [[ -f .env ]]; then
    # test .env syntax
    zsh -fn .env || echo 'dotenv: error when sourcing `.env` file' >&2

    if [[ -o a ]]; then
      source .env
    else
      set -a
      source .env
      set +a
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env

source_env
