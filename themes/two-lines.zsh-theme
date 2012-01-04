local magenta=$fg[magenta]
local blue=$fg[blue]
local red=$fg[red]
local green=$fg[green]

# Show a unicode character representing your current ruby VM.
function _show_rvm_prompt() {
  local rvm_char
  if [ -x "${HOME}/.rvm/bin/rvm-prompt" ]; then
    rvm_char=`${HOME}/.rvm/bin/rvm-prompt u 2>/dev/null`
    [ -n "${rvm_char}" ] && echo "${rvm_char} "
  fi
}

local return_code="%(?..%{$red%}%? ↵%{$reset_color%})"


PROMPT='%{$magenta%}%n@%m%{$reset_color%}: %{$blue%}%~ $(git_prompt_info)%{$reset_color%}
$(_show_rvm_prompt)> '

RPS1="${return_code}"


ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$blue%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$red%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$green%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""