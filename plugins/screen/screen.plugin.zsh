# if using GNU screen, let the zsh tell screen what the title and hardstatus
# of the tab window should be.

#put 'SCREENTAB_USE_HOST="no"' in .zshrc to hide the hostname in the title
#put 'SCREENTAB_USE_PATH="no"' in .zshrc to hide the current path in the title

if [[ "$TERM" == screen* ]]; then
  #Find the path and host.
  #The path should always be found because it's used in TAB_HARDSTATUS_PREFIX
  if [[ $_GET_PATH == '' ]]; then
    _GET_PATH='echo $PWD | sed "s/^\/Users\//~/;s/^\/home\//~/;s/^~$USER/~/"'
  fi
  if [[ $_GET_HOST == '' && ! $SCREENTAB_USE_HOST == "no" ]]; then
    _GET_HOST='echo $HOST | sed "s/\..*//"'
  fi

  # use the hostname and current path as the prefix of the current tab title
  TAB_TITLE_PREFIX='"'
  if [[ ! $SCREENTAB_USE_HOST == "no" ]]; then
    TAB_TITLE_PREFIX=$TAB_TITLE_PREFIX'$('$_GET_HOST'):'
  fi
  if [[ ! $SCREENTAB_USE_PATH == "no" ]]; then
    TAB_TITLE_PREFIX=$TAB_TITLE_PREFIX'$('$_GET_PATH' | sed "s:..*/::"):'
  fi
  TAB_TITLE_PREFIX=$TAB_TITLE_PREFIX'$PROMPT_CHAR"'
  # when at the shell prompt, show a truncated version of the current path (with
  # standard ~ replacement) as the rest of the title.
  TAB_TITLE_PROMPT='$SHELL:t'
  # when running a command, show the title of the command as the rest of the
  # title (truncate to drop the path to the command)
  TAB_TITLE_EXEC='$cmd[1]:t'

  # use the current path (with standard ~ replacement) in square brackets as the
  # prefix of the tab window hardstatus.
  TAB_HARDSTATUS_PREFIX='"[$('$_GET_PATH')] "'
  # when at the shell prompt, use the shell name (truncated to remove the path to
  # the shell) as the rest of the title
  TAB_HARDSTATUS_PROMPT='$SHELL:t'
  # when running a command, show the command name and arguments as the rest of
  # the title
  TAB_HARDSTATUS_EXEC='$cmd'

  # tell GNU screen what the tab window title ($1) and the hardstatus($2) should be
  screen_set() {
    # set the tab window title (%t) for screen
    print -nR $'\033k'$1$'\033'\\\

    # set hardstatus of tab window (%h) for screen
    print -nR $'\033]0;'$2$'\a'
    return 0
  }
  # called by zsh before executing a command
  preexec() {
    local -a cmd; cmd=(${(z)1}) # the command string
    eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_EXEC"
    eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX:$TAB_HARDSTATUS_EXEC"
    screen_set $tab_title $tab_hardstatus
    return 0
  }
  # called by zsh before showing the prompt
  precmd() {
    eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_PROMPT"
    eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX:$TAB_HARDSTATUS_PROMPT"
    screen_set $tab_title $tab_hardstatus
    return 0
  }
fi
