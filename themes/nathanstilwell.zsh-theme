#
#	Available Color Options are :
#
#	red, green, blue, cyan, magenta, yellow, white, black
#
#	Reference to what stuff in the Prompt is:
#	%n = username
#	%~ = pwd
#	%m = machine name
#

# $FG[025] - dark blue
# $FG[050] - cyan
# $FG[075] - light blue
# $FG[100] - muddy yellow
# $FG[125] - strawberry
# $FG[145] - white

PROMPT='%{$fg[green]%}[$(collapse_pwd)]
%{$fg[cyan]%}$(git_prompt_short_sha)%{$reset_color%}$(git_prompt_info)%{$reset_color%} > '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ✼%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%} ⌘"

RPROMPT='${return_status}$(git_prompt_status) %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} +++"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ***"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ---"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ≫≫≫"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ⏀"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[magenta]%} ???"

#
#	Convert the home directory to "~"
#	(Courtesy of Mr. Steve Losh)
#

function collapse_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

#
#	Some Special Characters if you want to swap out the prompts
#	-----------------------------------------------------------
#	✰ ✼ ✪ ✙ ♔ ♘ ♜ ♛ ♚ ♞ ♬ ⏀ ⌦ ⌘ ≫ ⇪ ☩ ☀ ☂ ★ ⚓ Ө β δ Σ Ω μ Δ ↪


