# ------------------------------------------------------------------------
# Juan G. Hurtado ZSH theme
# (Needs Git plugin)
# ------------------------------------------------------------------------

# Get current commit short SHA (formatted and coloured)
function git_prompt_sha() {
  sha=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "%{$fg[white]%}[%{$fg[yellow]%}"$sha"%{$fg[white]%}]"
}

# Prompts
PROMPT='
%{$fg[green]%}%n@%m%{$fg[white]%}:%{$fg[yellow]%}%~%u$(parse_git_dirty)%{$reset_color%}
%{$fg[blue]%}>%{$reset_color%} '
RPROMPT='%{$fg[green]%}$(current_branch) $(git_prompt_sha) $(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$fg[red]%}unmerged "
ZSH_THEME_GIT_PROMPT_DELETED=" %{$fg[red]%}deleted "
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$fg[yellow]%}renamed "
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg[yellow]%}modified "
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg[green]%}added "
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg[white]%}untracked "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}(*)"
ZSH_THEME_GIT_PROMPT_CLEAN=""