# ------------------------------------------------------------------------
# Juan G. Hurtado ZSH theme
# (Needs Git plugin)
# ------------------------------------------------------------------------

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$fg[red]%}unmerged "
ZSH_THEME_GIT_PROMPT_DELETED=" %{$fg[red]%}deleted "
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$fg[yellow]%}renamed "
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg[yellow]%}modified "
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg[green]%}added "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}untracked "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}(*)"
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg[red]%}(!)"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Get current commit short SHA (formatted and coloured)
function git_prompt_sha() {
  sha=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "$sha"
}

# Checks if there are commits ahead from remote
function git_prompt_ahead() {
  if $(echo "$(git log origin/master..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Prompts
PROMPT='
%{$fg_bold[green]%}%n@%m%{$fg[white]%}:%{$fg[yellow]%}%~%u$(parse_git_dirty)$(git_prompt_ahead)%{$reset_color%}
%{$fg[blue]%}>%{$reset_color%} '
RPROMPT='%{$fg_bold[green]%}$(current_branch) %{$fg[white]%}[%{$fg[yellow]%}$(git_prompt_sha)%{$fg[white]%}] $(git_prompt_status)%{$reset_color%}'