# Absolute path to this file's directory.
typeset __colored_man_pages_dir="${0:A:h}"

function colored() {
  local -a environment

  # Prefer `less` whenever available, since we specifically configured
  # environment for it.
  environment+=( PAGER="${commands[less]:-$PAGER}" )

  # See ./nroff script.
  if [[ "$OSTYPE" = solaris* ]]; then
    environment+=( PATH="${__colored_man_pages_dir}:$PATH" )
  fi

  command env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    $environment \
      "$@"
}

# Colorize man and dman/debman (from debian-goodies)
function man \
  dman \
  debman {
  colored $0 "$@"
}
