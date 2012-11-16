#!/usr/bin/env bash

# bash completion for Node Version Manager (NVM)

__nvm_generate_completion()
{
  declare current_word
  current_word="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "$1" -- "$current_word"))
  return 0
}

__nvm_commands ()
{
  declare current_word
  declare command

  current_word="${COMP_WORDS[COMP_CWORD]}"

  COMMANDS='\
    help install uninstall use run\
    ls ls-remote list list-remote deactivate\
    alias unalias copy-packages clear-cache version'

    if [ ${#COMP_WORDS[@]} == 4 ]; then

      command="${COMP_WORDS[COMP_CWORD-2]}"
      case "${command}" in
      alias)  __nvm_installed_nodes ;;
      esac

    else

      case "${current_word}" in
      -*)     __nvm_options ;;
      *)      __nvm_generate_completion "$COMMANDS" ;;
      esac

    fi
}

__nvm_options ()
{
  OPTIONS=''
  __nvm_generate_completion "$OPTIONS"
}

__nvm_installed_nodes ()
{
  __nvm_generate_completion "$(nvm_ls) $(__nvm_aliases)"
}

__nvm_aliases ()
{
  declare aliases
  aliases=""
  if [ -d $NVM_DIR/alias ]; then
    aliases="`cd $NVM_DIR/alias && ls`"
  fi
  echo "${aliases}"
}

__nvm_alias ()
{
  __nvm_generate_completion "$(__nvm_aliases)"
}

__nvm ()
{
  declare previous_word
  previous_word="${COMP_WORDS[COMP_CWORD-1]}"

  case "$previous_word" in
  use|run|ls|list|uninstall) __nvm_installed_nodes ;;
  alias|unalias)  __nvm_alias ;;
  *)              __nvm_commands ;;
  esac

  return 0
}

complete -o default -o nospace -F __nvm nvm
