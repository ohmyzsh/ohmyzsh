MODE_INDICATOR='%U'

ZSH_THEME_GIT_PROMPT_STAGED='%F{yellow}'
ZSH_THEME_GIT_PROMPT_DIRTY='%F{red}'
ZSH_THEME_GIT_PROMPT_CLEAN='%F{green}'
ZSH_THEME_GIT_PROMPT_DIVERGED='↕'
ZSH_THEME_GIT_PROMPT_AHEAD='↑'
ZSH_THEME_GIT_PROMPT_BEHIND='↓'
ZSH_THEME_GIT_PROMPT_UPTODATE='|'

function git_prompt_info() {
  git rev-parse 2> /dev/null || return
  ref=$(git symbolic-ref HEAD 2> /dev/null || print '(no branch)')
  echo "$(git_prompt_ahead)$(parse_git_dirty)${ref#refs/heads/}"
}

PROMPT='$(vi_mode_prompt_info 2> /dev/null)%m:%F{blue}%1~%f$(git_prompt_info)%{%(?.%F{green}.%F{red})%}%(!.#.>)%f%u '
RPS1='%(?..%F{red}%? )%F{yellow}$(git_prompt_short_sha)%f'
