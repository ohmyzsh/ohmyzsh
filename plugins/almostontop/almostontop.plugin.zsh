if [ "x$ALMOSONTOP" = "xfalse" ]; then
  # doing nothing here
else
  ALMOSONTOP=true
fi

function almostontop_preexec
{
  if [ "x$ALMOSONTOP" = "xtrue" ]; then
    clear
    # print PROMPT and command itself on the top
    echo "$(print -P $prompt)$fg[green]${(z)1}$reset_color"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec almostontop_preexec

function almostontop
{
  # Help message if there no args
  if [ $# -eq 0 ]; then
    almostontop_usage
  fi

  local arg=$1
  if [ "x$arg" = "xon" ]; then
    ALMOSONTOP=true
  fi

  if [ "x$arg" = "xoff" ]; then
    ALMOSONTOP=false
  fi

  if [ "x$arg" = "xtoggle" ]; then
    if [ "x$ALMOSONTOP" = "xtrue" ]; then
      almostontop off
    else
      almostontop on
    fi
  fi
}

function almostontop_usage
{
  cat <<-EOF
Usage: almostontop <command>

Commands:
  on     Enables almostontop plugin
  off    Disables almostontop plugin
  toggle Toggles almostontop plugin

Description:
  almostontop clears previous command output every time before new command
  executed in shell. Insipred by 'alwaysontop' plugin for bash:
  https://github.com/swirepe/alwaysontop
EOF
}
