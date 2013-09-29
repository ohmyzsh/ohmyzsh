function prompt_char {
    git branch >/dev/null 2>/dev/null && echo 'GIT ☢ ↪' && return
    hg root >/dev/null 2>/dev/null && echo 'HG ☢ ↪' && return
    echo ' ☣ ↪'
}
function battery_charge() {
    if [ -e /usr/local/bin/batcharge.py ]
    then
        echo `python /usr/local/bin/batcharge.py`
    else
        echo '';
    fi
}

function hg_prompt_info {
  if [ $(in_hg) ]; then
    hg prompt "{rev}:{node|short} on {root|basename}:{branch} {task} {status|modified} {patch|count|unapplied} {incoming changes{incoming|count}} {update}" 2>/dev/null
  fi
}

function get_pwd() {
   echo "${PWD/$HOME/~}"
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('on `basename $VIRTUAL_ENV`') '
}
function spacing {
  local spacing=""
  for i in {1..$termwidth}; do
      spacing="${spacing} "
  done
  echo $spacing
}
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

if which rbenv &> /dev/null; then
  PROMPT='%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%} %~ %{$reset_color%}$(hg_prompt_info)$(git_prompt_info)%{$reset_color%}
   $(prompt_char)  '
  RPROMPT='using %{$fg[red]%}$(rbenv version | sed -e "s/ (set.*$//")%{$reset_color%}$(virtualenv_info) %{$fg[magenta]%}$(date "+%Y-%m-%d")%{$reset_color%} BAT: $(battery_charge)'

fi



ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[white]%}%{$bg[red]%} ✖ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}%{$bg[magenta]%} ◘ "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔ "
