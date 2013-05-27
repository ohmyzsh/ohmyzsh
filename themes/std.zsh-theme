# -----------------------------------------------------------------------------
#          FILE: std.zsh-theme
#   DESCRIPTION: oh-my-zsh theme file
#        AUTHOR: Andrii Grytsenko <andrii.grytsenko@gmail.com>
#       VERSION: 0.1
#    SCREENSHOT: http://s23.postimg.org/dlcljx5kb/std.png
# -----------------------------------------------------------------------------

NOT_OK="%{$fg[red]%} ✸ %{$reset_color%}"
OK="%{$fg[green]%} ✸ %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=$NOT_OK
ZSH_THEME_GIT_PROMPT_CLEAN=$OK

ZSH_THEME_VAGRANT_PROMPT_OFF=$NOT_OK
ZSH_THEME_VAGRANT_PROMPT_ON=$OK

PROMPT='%{$fg[red]%}%n@%m%{$reset_color%}%{$fg_bold[red]%} %{$reset_color%}%{$fg[white]%}%0~%{$reset_color%}%{$fg_bold[blue]%} => %{$reset_color%} '
RPROMPT='%{$reset_color%}%{$fg_bold[blue]%}$(git_prompt_short_sha)$(git_prompt_no_changed_files) $(git_prompt_info) $(vagrant_prompt_status)%{$reset_color%}'
