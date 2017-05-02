# Twig autocompletion for oh-my-zsh
# Requires: Twig (https://github.com/rondevera/twig)
# Author: Antonio Murdaca (me@runcom.ninja)

_twig_branches() {
  compadd "$@" $(git for-each-ref refs/heads/ --format="%(refname:short)" | tr '\n' ' ')
}

_twig_formats() {
  compadd "$@" json
}

_twig_subcommands() {
  _subcommands=()
  for p in $(echo $PATH | tr ":" " "); do
    command=$(test -e $p && ls $p | grep "twig\-" | sed "s/twig-//")
    _subcommands+=($(echo $command | awk '{ print $1 }'))
  done
  compadd "$@" -k _subcommands
}

_twig () {
  if [ -z "$(git rev-parse HEAD 2>/dev/null)"  ]; then
    return 0;
  fi

  local curcontext="$curcontext" state line
  typeset -A opt_args

  _arguments \
    '1: :->command' \
    '*: :->args'

  case $state in
    command) _twig_subcommands ;;
    *)
      case $words[2] in
        -b|--branch)  _twig_branches ;;
        --format)     _twig_formats ;;
        diff)         _twig_branches ;;
        diff-branch)  _twig_branches ;;
        rebase)       _twig_branches ;;
        *)            ;;
      esac
      ;;
  esac

  return 0
}

compdef _twig twig
