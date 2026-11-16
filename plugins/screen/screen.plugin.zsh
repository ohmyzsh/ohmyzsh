# if using GNU screen, adjust the default hard status (window title) and window name (tab title)
if [[ "$TERM" == screen* ]]; then
  # use the current user as the prefix of the current tab title
  TAB_TITLE_PREFIX='"%m:%~$PROMPT_CHAR"'
  # when at the shell prompt, show a truncated version of the current path (with
  # standard ~ replacement) as the rest of the title.
  # used in omz_termsupport_precmd() before showing the prompt
  ZSH_THEME_TERM_TAB_TITLE_IDLE="%m:%15<..<%~%<<:$SHELL:t" # matching existing code
  ZSH_THEME_TERM_TAB_TITLE_IDLE="%n@%m:%15<..<%~%<<" # what the comments say...
  # when running a command, show the title of the command as the rest of the
  # title (truncate to drop the path to the command)
  TAB_TITLE_EXEC='$cmd[1]:t'

  # use the current path (with standard ~ replacement) in square brackets as the
  # prefix of the tab window hardstatus.
  TAB_HARDSTATUS_PREFIX='"[%~] "'
  # when at the shell prompt, use the shell name (truncated to remove the path to
  # the shell) as the rest of the title
  # used in omz_termsupport_precmd() before showing the prompt
  ZSH_THEME_TERM_TITLE_IDLE="[%~]:$SHELL:t"
  # when running a command, show the command name and arguments as the rest of
  # the title
  TAB_HARDSTATUS_EXEC='$cmd'

  # called by zsh before executing a command
  function omz_termsupport_preexec()
  {
    local -a cmd; cmd=(${(z)1}) # the command string
    eval "tab_title=$TAB_TITLE_PREFIX:$TAB_TITLE_EXEC"
    eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX:$TAB_HARDSTATUS_EXEC"
    title $tab_title $tab_hardstatus
  }
fi
