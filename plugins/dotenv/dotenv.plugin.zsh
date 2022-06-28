## Settings

# Filename of the dotenv file to look for
: ${ZSH_DOTENV_FILE:=.env}

# Path to the file containing allowed paths
: ${ZSH_DOTENV_ALLOWED_LIST:="${ZSH_CACHE_DIR:-$ZSH/cache}/dotenv-allowed.list"}
: ${ZSH_DOTENV_DISALLOWED_LIST:="${ZSH_CACHE_DIR:-$ZSH/cache}/dotenv-disallowed.list"}


## Functions

source_env() {
  if [[ ! -f "$ZSH_DOTENV_FILE" ]]; then
    return
  fi

  if [[ "$ZSH_DOTENV_PROMPT" != false ]]; then
    local confirmation dirpath="${PWD:A}"

    # make sure there is an (dis-)allowed file
    touch "$ZSH_DOTENV_ALLOWED_LIST"
    touch "$ZSH_DOTENV_DISALLOWED_LIST"

    # early return if disallowed
    if command grep -Fx -q "$dirpath" "$ZSH_DOTENV_DISALLOWED_LIST" &>/dev/null; then
      return
    fi

    # check if current directory's .env file is allowed or ask for confirmation
    if ! command grep -Fx -q "$dirpath" "$ZSH_DOTENV_ALLOWED_LIST" &>/dev/null; then
      # get cursor column and print new line before prompt if not at line beginning
      local column
      echo -ne "\e[6n" > /dev/tty
      read -t 1 -s -d R column < /dev/tty
      column="${column##*\[*;}"
      [[ $column -eq 1 ]] || echo

      # print same-line prompt and output newline character if necessary
      echo -n "dotenv: found '$ZSH_DOTENV_FILE' file. Source it? ([Y]es/[n]o/[a]lways/n[e]ver) "
      read -k 1 confirmation
      [[ "$confirmation" = $'\n' ]] || echo

      # check input
      case "$confirmation" in
        [nN]) return ;;
        [aA]) echo "$dirpath" >> "$ZSH_DOTENV_ALLOWED_LIST" ;;
        [eE]) echo "$dirpath" >> "$ZSH_DOTENV_DISALLOWED_LIST"; return ;;
        *) ;; # interpret anything else as a yes
      esac
    fi
  fi

  # test .env syntax
  zsh -fn $ZSH_DOTENV_FILE || {
    echo "dotenv: error when sourcing '$ZSH_DOTENV_FILE' file" >&2
    return 1
  }

  setopt localoptions allexport
  source $ZSH_DOTENV_FILE
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env

source_env
