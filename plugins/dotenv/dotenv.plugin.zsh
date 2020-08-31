## Settings

# Filename of the dotenv file to look for
: ${ZSH_DOTENV_FILE:=.env}

# Path to the file containing allowed paths
: ${ZSH_DOTENV_ALLOWED_LIST:="${ZSH_CACHE_DIR:-$ZSH/cache}/dotenv-allowed.list"}
: ${ZSH_DOTENV_DISALLOWED_LIST:="${ZSH_CACHE_DIR:-$ZSH/cache}/dotenv-disallowed.list"}


## Functions

source_env() {
  if [[ -f $ZSH_DOTENV_FILE ]]; then
    if [[ "$ZSH_DOTENV_PROMPT" != false ]]; then
      local confirmation dirpath="${PWD:A}"

      # make sure there is an (dis-)allowed file
      # Will fail if $ZSH and $ZSH_CACHE_DIR are both undefined but the script
      # will keep going
      touch "$ZSH_DOTENV_ALLOWED_LIST" 2>/dev/null
      touch "$ZSH_DOTENV_DISALLOWED_LIST" 2>/dev/null

      local allowed_list_opt=''
      local disallowed_list_opt=''
      if [ -f "$ZSH_DOTENV_ALLOWED_LIST" ] ; then
        allowed_list_opt='/[a]lways'
      fi

      if [ -f "$ZSH_DOTENV_DISALLOWED_LIST" ] ; then
        disallowed_list_opt='/n[e]ver'
      fi

      # early return if disallowed
      if grep -q "$dirpath" "$ZSH_DOTENV_DISALLOWED_LIST" &>/dev/null; then
        return;
      fi

      # check if current directory's .env file is allowed or ask for confirmation
      if ! grep -q "$dirpath" "$ZSH_DOTENV_ALLOWED_LIST" &>/dev/null; then
        # print same-line prompt and output newline character if necessary
        echo -n "dotenv: found '$ZSH_DOTENV_FILE' file. Source it? ([Y]es/[n]o${allowed_list_opt}${disallowed_list_opt})"
        read -k 1 confirmation; [[ "$confirmation" != $'\n' ]] && echo

        # check input
        case "$confirmation" in
          [nN]) return ;;
          [aA]) if [ -f "$ZSH_DOTENV_ALLOWED_LIST" ] ; then echo "$dirpath" >> "$ZSH_DOTENV_ALLOWED_LIST" ; fi ;;
          [eE]) if [ -f "$ZSH_DOTENV_DISALLOWED_LIST" ] ; then echo "$dirpath" >> "$ZSH_DOTENV_DISALLOWED_LIST" ; fi ; return ;;
          *) ;; # interpret anything else as a yes
        esac
      fi
    fi

    # test .env syntax
    zsh -fn $ZSH_DOTENV_FILE || echo "dotenv: error when sourcing '$ZSH_DOTENV_FILE' file" >&2

    setopt localoptions allexport
    source $ZSH_DOTENV_FILE
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env

source_env
