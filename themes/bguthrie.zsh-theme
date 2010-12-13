
setopt nocorrect

# Found on the ZshWiki
#  http://zshwiki.org/home/config/prompt
function prompt_char {
  git branch >/dev/null 2>/dev/null && echo "%{$fg[blue]%}λ" && return
  # These are slow and have therefore been killed:
  # svn info >/dev/null 2>/dev/null && echo 'λ' && return
  # hg root >/dev/null 2>/dev/null && echo 'λ' && return
  echo '$'
}

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Parsing git dirty status slows down my prompt tremendously without adding much value.
# This variant of git_prompt_info just grabs the branch.
function git_current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX%{$fg[blue]%}${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# PROMPT='[%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}:%{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(git_prompt_info)]
# $(prompt_char) '
# PROMPT='[%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}:%{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(git_prompt_info)]
# λ '
# PROMPT='[%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}:%{$fg_bold[green]%}%~%{$reset_color%}]
# λ '
PROMPT='[%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}:%{$fg_bold[green]%}%~%{$reset_color%}$(git_current_branch)] $(prompt_char)%{$reset_color%} '
