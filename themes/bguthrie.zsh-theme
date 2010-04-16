# Found on the ZshWiki
#  http://zshwiki.org/home/config/prompt
#

# As lifted from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
function collapse_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
  git branch >/dev/null 2>/dev/null && echo 'λ' && return
  hg root >/dev/null 2>/dev/null && echo 'λ' && return
  svn info >/dev/null 2>/dev/null && echo 'λ' && return
  echo '$'
}

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='[%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}:%{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(git_prompt_info)]
$(prompt_char) '
