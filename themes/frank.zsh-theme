local ret_status="%(?::%{$fg_bold[red]%}%s)(%?)%{$reset_color%}"
PROMPT='${ret_status} %{$fg_bold[green]%}%n@%m %{$fg_bold[blue]%}[%3~]%{$reset_color%} %# '
RPS1='$(git_prompt_info) %{$reset_color%}%T'
PS2='%{$fg_bold[blue]%}[%3~]%{$reset_color%} > '
RPS2='< %{$fg_bold[green]%}%_%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX="%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_BRANCH_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND_PREFIX="<"
ZSH_THEME_GIT_PROMPT_BEHIND_SUFFIX=""
ZSH_THEME_GIT_PROMPT_AHEAD_PREFIX=">"
ZSH_THEME_GIT_PROMPT_AHEAD_SUFFIX=""
ZSH_THEME_GIT_PROMPT_STAGED_PREFIX="%{$fg_bold[cyan]%}s"
ZSH_THEME_GIT_PROMPT_STAGED_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CONFLICT_PREFIX="%{$fg_bold[red]%}!"
ZSH_THEME_GIT_PROMPT_CONFLICT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CHANGED_PREFIX="%{$fg[yellow]%}+"
ZSH_THEME_GIT_PROMPT_CHANGED_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED_PREFIX="%{$fg[cyan]%}?"
ZSH_THEME_GIT_PROMPT_UNTRACKED_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN_PREFIX="%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

function git_status()
{
	GIT_STATUS="${branch}${behind}${ahead}:${clean}${staged}${changed}${conflict}${untracked}"
}
