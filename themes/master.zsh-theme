# Found on the ZshWiki
#  http://zshwiki.org/home/config/prompt
#

# ------------------------------------------------------------------------
# Juan G. Hurtado oh-my-zsh theme
# (Needs Git plugin for current_branch method)
# ------------------------------------------------------------------------
# copied from juanghurtado, and afowler themes

# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
GREY_BOLD=$fg_bold[grey]
RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
RESET_COLOR=$reset_color

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$RESET_COLOR}"

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$RED%}(⚡)"
ZSH_THEME_GIT_PROMPT_CLEAN=""
# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$YELLOW%}(↑)"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$RED_BOLD%}unm"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$RED%}del"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$BLUE%}ren"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$YELLOW%}mod"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$BLUE_BOLD%}add"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$GREEN%}unt"


# Prompt format
function rprompt_char() {
  git branch >/dev/null 2>/dev/null && echo "%{$fg[green]%}±%{$reset_color%}" && return
  hg root >/dev/null 2>/dev/null && echo "%{$fg_bold[blue]%}☿%{$reset_color%}" && return
}

if [ $UID -eq 0 ]; then CARETCOLOR="red"; else CARETCOLOR="white"; fi

PROMPT=$'┌─%{${BLUE}%}%n%{$RESET_COLOR%}@%{${GREEN}%}%m%{$RESET_COLOR%}:%{${GREY_BOLD}%}%3~$(parse_git_dirty)$(git_prompt_ahead) %{${RESET_COLOR}%} \n└─%{${fg_bold[$CARETCOLOR]}%}>>=%{${RESET_COLOR}%} '

RPROMPT='$(rprompt_char) %{$RED%}$(current_branch)$(current_branch_hg)$(git_prompt_status)%{$RESET_COLOR%}'
