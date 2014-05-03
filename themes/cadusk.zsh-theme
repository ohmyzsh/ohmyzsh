# cadusk ZSH Theme - customized on top of avit theme

PROMPT='
[$(_user_host) ${_current_dir}] $(git_prompt_info)
$ '
PROMPT2='%{$fg[white]%}$%{$reset_color%} '

RPROMPT='%{$(echotc UP 1)%} $(git_prompt_status) ${_return_status}%{$(echotc DO 1)%}'

local _current_dir="%F{208}%3~%f%{$reset_color%}"
local _return_status="%{$fg[red]%}%(?..⍉)%{$reset_color%}"
local _hist_no="%{$fg_bold[red]%}%h%{$reset_color%}"

function _user_host() {
  me="%{$fg_bold[white]%}%n"

  if [[ -n $SSH_CONNECTION ]]; then
    me="$me%{$fg_bold[black]%}@%m"
  fi
  echo "$me%b%{$reset_color%}"
}

if [[ $USER == "root" ]]; then
  CARETCOLOR="red"
else
  CARETCOLOR="white"
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[black]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[black]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# LS colors, made with http://geoff.greer.fm/lscolors/
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'

