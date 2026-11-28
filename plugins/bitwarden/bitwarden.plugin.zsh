# Autocompletion for the Bitwarden CLI (bw) and Secrets Manager CLI (bws).
() {
  local cli completion cache_file
  local -a generator_args
  for cli in bw bws; do
    completion="_$cli"
    cache_file="$ZSH_CACHE_DIR/completions/$completion"

    if (( ! $+commands[$cli] )); then
      # compinit can register a cached completion after the CLI is removed.
      if [[ -f "$cache_file" && ${_comps[$cli]-} == "$completion" ]]; then
        unset "_comps[$cli]"
      fi
      continue
    fi

    case "$cli" in
      bw)
        generator_args=(completion --shell zsh)
        # bw emits function definitions. Use ksh-style autoload to run _bw
        # on the first Tab press as well as loading its helper functions.
        autoload -Uk "$completion"
        ;;
      bws)
        generator_args=(completions zsh)
        autoload -Uz "$completion"
        ;;
    esac
    # Register the completion if compinit hasn't picked it up yet.
    if [[ -z ${_comps[$cli]-} ]]; then
      _comps[$cli]=$completion
    fi

    () {
      zmodload -F zsh/files b:zf_mv || return
      local temp_file
      temp_file=$(mktemp "${cache_file:h}/.$completion.XXXXXXXX") || return
      if command "$cli" "$@" >| "$temp_file" && [[ -s "$temp_file" ]] &&
        zf_mv -f -- "$temp_file" "$cache_file"; then
        return
      fi
      rm -f -- "$temp_file"
    } "${generator_args[@]}" &|
  done
}
