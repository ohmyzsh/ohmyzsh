# ----------------------------------------------------------------------------
# prompt variables
# ----------------------------------------------------------------------------
ZSH_PROMPT_BASE_COLOR="%{$FG[243]%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[243]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_HG_PROMPT_PREFIX="hg:("
ZSH_THEME_HG_PROMPT_SUFFIX=""
ZSH_THEME_HG_PROMPT_DIRTY="*)"
ZSH_THEME_HG_PROMPT_CLEAN=")"

ZSH_THEME_SVN_PROMPT_PREFIX="svn:("
ZSH_THEME_SVN_PROMPT_SUFFIX=""
ZSH_THEME_SVN_PROMPT_DIRTY="*)"
ZSH_THEME_SVN_PROMPT_CLEAN=")"

# ----------------------------------------------------------------------------
# zee prompt (ha ha)
# ----------------------------------------------------------------------------
PROMPT='%{$fg_bold[blue]%}%n@%m %{$fg[green]%}${PWD/#$HOME/~}%b%{$reset_color%} '
RPROMPT='$(hg_prompt_info)$(git_prompt_info)$(svn_prompt_info)%{$reset_color%}'