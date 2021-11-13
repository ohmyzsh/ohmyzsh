_FOSSIL_PROMPT=""

# Prefix at the very beginning of the prompt, before the branch name
ZSH_THEME_FOSSIL_PROMPT_PREFIX="%{$fg_bold[blue]%}fossil:(%{$fg_bold[red]%}"

# At the very end of the prompt
ZSH_THEME_FOSSIL_PROMPT_SUFFIX="%{$fg_bold[blue]%})"

# Text to display if the branch is dirty
ZSH_THEME_FOSSIL_PROMPT_DIRTY=" %{$fg_bold[red]%}✖"

# Text to display if the branch is clean
ZSH_THEME_FOSSIL_PROMPT_CLEAN=" %{$fg_bold[green]%}✔"

function fossil_prompt_info () {
  local _OUTPUT=`fossil branch 2>&1`
  local _STATUS=`echo $_OUTPUT | grep "use --repo"`
  if [ "$_STATUS" = "" ]; then
    local _EDITED=`fossil changes`
    local _EDITED_SYM="$ZSH_THEME_FOSSIL_PROMPT_CLEAN"
    local _BRANCH=`echo $_OUTPUT | grep "* " | sed 's/* //g'`

    if [ "$_EDITED" != "" ]; then
      _EDITED_SYM="$ZSH_THEME_FOSSIL_PROMPT_DIRTY"
    fi

    echo "$ZSH_THEME_FOSSIL_PROMPT_PREFIX" \
      "$_BRANCH" \
      "$ZSH_THEME_FOSSIL_PROMPT_SUFFIX" \
      "$_EDITED_SYM"\
      "%{$reset_color%}"
  fi
}

function _fossil_get_command_list () {
  fossil help -a | grep -v "Usage|Common|This is"
}

function _fossil () {
  local context state state_descr line
  typeset -A opt_args

  _arguments \
    '1: :->command'\
    '2: :->subcommand'

  case $state in
    command)
      local _OUTPUT=`fossil branch 2>&1 | grep "use --repo"`
      if [ "$_OUTPUT" = "" ]; then
        compadd `_fossil_get_command_list`
      else
        compadd clone init import help version
      fi
      ;;
    subcommand)
      if [ "$words[2]" = "help" ]; then
        compadd `_fossil_get_command_list`
      else
        compcall -D
      fi
    ;;
  esac
}

function _fossil_prompt () {
  local current=`echo $PROMPT $RPROMPT | grep fossil`

  if [ "$_FOSSIL_PROMPT" = "" -o "$current" = "" ]; then
    local _prompt=${PROMPT}
    local _rprompt=${RPROMPT}

    local is_prompt=`echo $PROMPT | grep git`

    if [ "$is_prompt" = "" ]; then
      RPROMPT="$_rprompt"'$(fossil_prompt_info)'
    else
      PROMPT="$_prompt"'$(fossil_prompt_info) '
    fi

    _FOSSIL_PROMPT="1"
  fi
}

compdef _fossil fossil

autoload -U add-zsh-hook

add-zsh-hook precmd _fossil_prompt
