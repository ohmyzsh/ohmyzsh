# Fewer than 47 columns will probably work. Haven't tried it.
typeset -gr __p9k_wizard_columns=47
# The bottleneck is ask_tails with nerd fonts. Everything else works fine with 12 lines.
typeset -gr __p9k_wizard_lines=14
typeset -gr __p9k_zd=${ZDOTDIR:-$HOME}
typeset -gr __p9k_zd_u=${${${(q)__p9k_zd}/#(#b)${(q)HOME}(|\/*)/'~'$match[1]}//\%/%%}
typeset -gr __p9k_zshrc=${${:-$__p9k_zd/.zshrc}:A}
typeset -gr __p9k_zshrc_u=$__p9k_zd_u/.zshrc
typeset -gr __p9k_root_dir_u=${${${(q)__p9k_root_dir}/#(#b)${(q)HOME}(|\/*)/'~'$match[1]}//\%/%%}

function _p9k_can_configure() {
  [[ $1 == '-q' ]] && local -i q=1 || local -i q=0
  function $0_error() {
    (( q )) || print -rP "%1F[ERROR]%f %Bp10k configure%b: $1" >&2
  }
  typeset -g __p9k_cfg_path_o=${POWERLEVEL9K_CONFIG_FILE:=${ZDOTDIR:-~}/.p10k.zsh}
  typeset -g __p9k_cfg_basename=${__p9k_cfg_path_o:t}
  typeset -g __p9k_cfg_path=${__p9k_cfg_path_o:A}
  typeset -g __p9k_cfg_path_u=${${${(q)__p9k_cfg_path_o}/#(#b)${(q)HOME}(|\/*)/'~'$match[1]}//\%/%%}
  {
    [[ -o multibyte ]]         || { $0_error "multibyte option is not set";      return 1 }
    [[ -e $__p9k_zd ]]         || { $0_error "$__p9k_zd_u does not exist";       return 1 }
    [[ -d $__p9k_zd ]]         || { $0_error "$__p9k_zd_u is not a directory";   return 1 }
    [[ ! -d $__p9k_cfg_path ]] || { $0_error "$__p9k_cfg_path_u is a directory"; return 1 }
    [[ ! -d $__p9k_zshrc ]]    || { $0_error "$__p9k_zshrc_u is a directory";    return 1 }

    local dir=${__p9k_cfg_path:h}
    while [[ ! -e $dir && $dir != ${dir:h} ]]; do dir=${dir:h}; done
    if [[ ! -d $dir ]]; then
      $0_error "cannot create $__p9k_cfg_path_u because ${dir//\%/%%} is not a directory"
      return 1
    fi
    if [[ ! -w $dir ]]; then
      $0_error "cannot create $__p9k_cfg_path_u because ${dir//\%/%%} is readonly"
      return 1
    fi

    [[ ! -e $__p9k_cfg_path || -f $__p9k_cfg_path || -h $__p9k_cfg_path ]] || {
      $0_error "$__p9k_cfg_path_u is a special file"
      return 1
    }
    [[ ! -e $__p9k_zshrc || -f $__p9k_zshrc || -h $__p9k_zshrc ]]          || {
      $0_error "$__p9k_zshrc_u a special file"
      return 1
    }
    [[ ! -e $__p9k_zshrc || -r $__p9k_zshrc ]]                             || {
      $0_error "$__p9k_zshrc_u is not readable"
      return 1
    }
    local style
    for style in lean lean-8colors classic rainbow pure; do
      [[ -r $__p9k_root_dir/config/p10k-$style.zsh ]]                      || {
        $0_error "$__p9k_root_dir_u/config/p10k-$style.zsh is not readable"
        return 1
      }
    done

    (( LINES >= __p9k_wizard_lines && COLUMNS >= __p9k_wizard_columns ))   || {
      $0_error "terminal size too small; must be at least $__p9k_wizard_columns columns by $__p9k_wizard_lines lines"
      return 1
    }
    [[ -t 0 && -t 1 ]]                                                     || {
      $0_error "no TTY"
      return 2
    }
    return 0
  } always {
    unfunction $0_error
  }
}

function p9k_configure() {
  eval "$__p9k_intro"
  _p9k_can_configure || return
  (
    set -- -f
    builtin source $__p9k_root_dir/internal/wizard.zsh
  )
  local ret=$?
  case $ret in
    0)  builtin source $__p9k_cfg_path; _p9k__force_must_init=1;;
    69) return 0;;
    *)  return $ret;;
  esac
}
