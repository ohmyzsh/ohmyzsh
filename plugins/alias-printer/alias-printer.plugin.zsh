alias-printer() {
  if [[ "$1" = "--on" ]]; then
    autoload -U add-zsh-hook;
    add-zsh-hook preexec alias-printer;
    echo "alias-printer turned on";
  fi
  if [[ "$1" = "--off" ]]; then
    autoload -U add-zsh-hook;
    add-zsh-hook -d preexec alias-printer;
    echo "alias-printer turned off";
  fi
  if [[ ! -z $2 ]]; then
    echo 'alias-printer: '"$2";
  fi
}
