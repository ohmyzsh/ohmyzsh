if [[ "$OSTYPE" = darwin* ]]; then
  cache_dir="${HOME}/Library/Caches"
else
  cache_dir="${XDG_CACHE_HOME:-"${HOME}/.cache"}"
fi

setup_path="${cache_dir}/heroku/autocomplete/zsh_setup"
[[ -f "$setup_path" ]] && source $setup_path
unset cache_dir setup_path
