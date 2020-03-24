# oh-my-zsh Bureau Theme

### NVM

ZSH_THEME_NVM_PROMPT_PREFIX="%B⬡%b "
ZSH_THEME_NVM_PROMPT_SUFFIX=""

### Git [±master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_bold[green]%}±%{$reset_color%}%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"

bureau_git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

bureau_git_status() {
  local gstatus
  gstatus=""

  # check status of files
  if [[ "$(command git config --get oh-my-zsh.hide-dirty 2> /dev/null)" != "1" ]]; then
    local flags index
    flags=('--porcelain')
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      flags+="--untracked-files=no"
    fi
    index=$(command git status $flags 2> /dev/null)
    case $index in
      [AMRD]?*) gstatus+=$ZSH_THEME_GIT_PROMPT_STAGED ;;
      ?[MTD]*) gstatus+=$ZSH_THEME_GIT_PROMPT_UNSTAGED ;;
      "?? "*) gstatus+=$ZSH_THEME_GIT_PROMPT_UNTRACKED ;;
      "UU "*) gstatus+=$ZSH_THEME_GIT_PROMPT_UNMERGED ;;
      "") gstatus+=$ZSH_THEME_GIT_PROMPT_CLEAN ;;
    esac
  fi

  # check status of local repository
  local ref
  ref=$(command git rev-parse --abbrev-ref HEAD 2> /dev/null)
  index=$(command git for-each-ref --format="%(upstream:track)" refs/heads/${ref} 2> /dev/null)
  if $(echo "$index" | command grep -q 'ahead'); then
    gstatus="$gstatus$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$index" | command grep -q 'behind'); then
    gstatus="$gstatus$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi

  if $(command git rev-parse --verify refs/stash &> /dev/null); then
    gstatus="$gstatus$ZSH_THEME_GIT_PROMPT_STASHED"
  fi

  echo $gstatus
}

bureau_git_prompt () {
  local _branch=$(bureau_git_branch)
  local _status=$(bureau_git_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$ZSH_THEME_GIT_PROMPT_PREFIX$_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi
    _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}


_PATH="%{$fg_bold[white]%}%~%{$reset_color%}"

if [[ $EUID -eq 0 ]]; then
  _USERNAME="%{$fg_bold[red]%}%n"
  _LIBERTY="%{$fg[red]%}#"
else
  _USERNAME="%{$fg_bold[white]%}%n"
  _LIBERTY="%{$fg[green]%}$"
fi
_USERNAME="$_USERNAME%{$reset_color%}@%m"
_LIBERTY="$_LIBERTY%{$reset_color%}"


get_space () {
  local STR=$1$2
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}}
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 1))

  for i in {0..$LENGTH}
    do
      SPACES="$SPACES "
    done

  echo $SPACES
}

_1LEFT="$_USERNAME $_PATH"
_1RIGHT="[%*] "

bureau_precmd () {
  _1SPACES=`get_space $_1LEFT $_1RIGHT`
  print
  print -rP "$_1LEFT$_1SPACES$_1RIGHT"
}

setopt prompt_subst
PROMPT='> $_LIBERTY '
RPROMPT='$(nvm_prompt_info) $(bureau_git_prompt)'

autoload -U add-zsh-hook
add-zsh-hook precmd bureau_precmd
