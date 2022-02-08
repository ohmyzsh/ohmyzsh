alias-printer() {
  for arg in $@; do
    case $arg in
      --on )
        autoload -U add-zsh-hook;
        add-zsh-hook preexec alias-printer;
        echo "alias-printer turned on";
        ;;
      --off )
        autoload -U add-zsh-hook;
        add-zsh-hook -d preexec alias-printer;
        echo "alias-printer turned off";
        ;;
      * )
        if [[ ! -z $2 ]]; then
          echo 'alias-printer: '"$2";
        fi
        break
      ;;
    esac
  done
}
