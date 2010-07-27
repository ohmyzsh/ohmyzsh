# ZSH Theme - alexg
# Based on 'gallifrey' theme to look like 
# git-prompt (http://volnitsky.com/project/git-prompt/)
#
# note: %F and %K dont work correctly on non-color terminals

local return_code="%(?,,%{$fg[red]%}%? ↵%{$reset_color%})"
local user_prompt_char="»"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%}"

local prompt_char="%B%(!,#,$user_prompt_char)%b"
local who_where="%(!,%{$fg[magenta]%}%n@%m,%{$fg[blue]%}%m)%{$reset_color%}"

PROMPT='$(git_prompt_info abbr)%1(l, ,)$who_where %{$fg[cyan]%}%2~ %{$reset_color%}$prompt_char '
RPS1="${return_code}"

# on dumb terminals, switch to simpler prompt char
# (for Emacs and tramp)
if [[ $TERM = 'dumb' ]]; then
  user_prompt_char='$' 
  # change prefix as not to confuse tramp and emacs-shell
  ZSH_THEME_GIT_PROMPT_PREFIX="["
  ZSH_THEME_GIT_PROMPT_SUFFIX="]"
  PROMPT='$ '
  PS1='$ '
  unsetopt zle
#  unsetopt prompt_cr
fi
