# Theme by [agnoster](https://github.com/agnoster)
# See https://gist.github.com/3712874

ZSH_THEME_GIT_PROMPT_DIRTY='±'

function _git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
  echo "${ref/refs\/heads\//⭠ }$(parse_git_dirty)"
}

function _git_info() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    local BG_COLOR=green
    if [[ -n $(parse_git_dirty) ]]; then
      BG_COLOR=yellow
    fi
    echo "%{%K{$BG_COLOR}%}⮀%{%F{black}%} $(_git_prompt_info) %{%F{$BG_COLOR}%K{blue}%}⮀"
  else
    echo "%{%K{blue}%}⮀"
  fi
}

PROMPT_HOST='%{%b%F{gray}%K{black}%} %(?.%{%F{green}%}✔.%{%F{red}%}✘)%{%F{gray}%} %m %{%F{black}%}'
PROMPT_DIR='%{%F{white}%} %1~ '
PROMPT_SU='%(!.%{%k%F{blue}%K{black}%}⮀%{%F{yellow}%} ⚡ %{%k%F{black}%}.%{%k%F{blue}%})⮀%{%f%k%b%}'

PROMPT='%{%f%b%k%}
$PROMPT_HOST$(_git_info)$PROMPT_DIR$PROMPT_SU '
