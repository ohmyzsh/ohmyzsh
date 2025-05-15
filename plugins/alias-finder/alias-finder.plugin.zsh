alias-finder() {
  local cmd=" " exact=false longer=false cheaper=false wordStart="^'?" wordEnd="'?$" finder="" filter=""

  # setup options
  # XXX: This logic has flaw. If user enable options with zstyle, there's no way to disable it.
  #      It's because same function is used for autoload hook and manual execution.
  #      I believe manual execution is very minor in use, so I'll keep it as is for now.
  for c in "$@"; do
    case $c in
      -e|--exact) exact=true;;
      -l|--longer) longer=true;;
      -c|--cheaper) cheaper=true;;
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

  $longer && wordEnd=".*$"

  # find with alias and grep, removing last word each time until no more words
  while [[ $cmd != "" ]]; do
    finder="$wordStart$cmd$wordEnd"

    # make filter to find only shorter results than current cmd
    if [[ $cheaper == true ]]; then
      cmdLen=$(echo -n "$cmd" | wc -c)
      if [[ $cmdLen -le 1 ]]; then
        return
      fi

      filter="^'?.{1,$((cmdLen - 1))}'?=" # some aliases is surrounded by single quotes
    fi

    alias | grep -E "$filter" | grep -E "=$finder"

    $exact && break # because exact case is only one
    $longer && break # because above grep command already found every longer aliases during first cycle

    cmd=$(sed -E 's/ {0,}[^ ]*$//' <<< "$cmd") # remove last word
  done
}

# add hook to run alias-finder before each command
preexec_alias-finder() {
  alias-finder "$1"
}
if zstyle -t ':omz:plugins:alias-finder' autoload ; then
  autoload -Uz alias-finder
  add-zsh-hook preexec preexec_alias-finder
elif [[ $ZSH_ALIAS_FINDER_AUTOMATIC = true ]]; then # TODO: remove this legacy style support
  autoload -Uz alias-finder
  add-zsh-hook preexec preexec_alias-finder
fi
