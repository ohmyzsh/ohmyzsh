alias-finder() {
  local cmd=" " exact="" longer="" cheaper="" wordEnd="'{0,1}$" finder="" filter=""

  # build command and options
  for c in "$@"; do
    case $c in
      # TODO: Remove backward compatibility (other than zstyle form)
      # set options if exist
      -e|--exact) exact=true;;
      -l|--longer) longer=true;;
      -c|--cheaper) cheaper=true;;
      # concatenate cmd
      *) cmd="$cmd$c " ;;
    esac
  done

  zstyle -t ':omz:plugins:alias-finder' longer && longer=true
  zstyle -t ':omz:plugins:alias-finder' exact && exact=true
  zstyle -t ':omz:plugins:alias-finder' cheaper && cheaper=true

  # format cmd for grep
  ## - replace newlines with spaces
  ## - trim both ends
  ## - replace multiple spaces with one space
  ## - add escaping character to special characters
  cmd=$(echo -n "$cmd" | tr '\n' ' ' | xargs | tr -s '[:space:]' | sed 's/[].\|$(){}?+*^[]/\\&/g')

  if [[ $longer == true ]]; then
    wordEnd="" # remove wordEnd to find longer aliases
  fi

  # find with alias and grep, removing last word each time until no more words
  while [[ $cmd != "" ]]; do
    finder="'{0,1}$cmd$wordEnd"

    # make filter to find only shorter results than current cmd
    if [[ $cheaper == true ]]; then
      cmdLen=$(echo -n "$cmd" | wc -c)
      if [[ $cmdLen -le 1 ]]; then
        return
      fi

      filter="^'?.{1,$((cmdLen - 1))}'?=" # some aliases is surrounded by single quotes
    fi

    if (( $+commands[rg] )); then
      alias | rg "$filter" | rg "=$finder"
    else
      alias | grep -E "$filter" | grep -E "=$finder"
    fi

    if [[ $exact == true ]]; then
      break # because exact case is only one
    elif [[ $longer == true ]]; then
      break # because above grep command already found every longer aliases during first cycle
    fi

    cmd=$(sed -E 's/ {0,}[^ ]*$//' <<< "$cmd") # remove last word
  done
}

preexec_alias-finder() {
  # TODO: Remove backward compatibility (other than zstyle form)
  zstyle -t ':omz:plugins:alias-finder' autoload && alias-finder $1 || if [[ $ZSH_ALIAS_FINDER_AUTOMATIC = true ]]; then
    alias-finder $1
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec preexec_alias-finder
