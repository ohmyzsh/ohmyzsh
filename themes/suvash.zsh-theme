function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo 'Hg' && return
    echo '○'
}

function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_rvm_ruby {
if which rvm-prompt &> /dev/null; then
  echo $(rvm-prompt i v g)
fi
}

function prompt_python_version {
if which python &> /dev/null; then
  echo 'python-'`python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))'`
fi
}

function prompt_pythonbrew_python {
if which pythonbrew  &> /dev/null; then
  if [ $VIRTUAL_ENV ]; then
    echo $(prompt_python_version)'#'`basename $VIRTUAL_ENV`
  else
    echo $(prompt_python_version)
  fi
fi
}

function prompt_right_dynamic_length {
if [ "${COLUMNS}" -gt "160" ]; then
  echo "%{$fg[red]%}$(prompt_rvm_ruby)%{$reset_color%} ‹ %{$fg[red]%}$(prompt_pythonbrew_python)%{$reset_color%}"
elif [ "${COLUMNS}" -gt "80" ]; then
  echo "%{$fg[red]%}$(prompt_rvm_ruby)%{$reset_color%}"
else
  echo ""
fi
}

ZSH_THEME_GIT_PROMPT_PREFIX=" › %{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_UNTRACKED=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%}⚐%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}⚈%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚆%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}⚒%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}⚛%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}☢%{$reset_color%}"


PROMPT='%{$fg[magenta]%}%n%{$reset_color%}%{$fg[blue]%}@%{$reset_color%}%{$fg[magenta]%}%m%{$reset_color%} › %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)$(git_prompt_status)%{$reset_color%}
$(prompt_char) '

RPROMPT='$(prompt_right_dynamic_length)'

