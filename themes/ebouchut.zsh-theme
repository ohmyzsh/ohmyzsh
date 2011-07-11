# ebouchut ZSH Theme
#
# author: Eric Bouchut
#
# Left Prompt:
#   username@hostname:current_directory%  
#
# Right prompt when in a Git repository:
#      ±‹branch_name clean_or_dirty ahead [short_sha] status›
#

ZSH_THEME_GIT_PROMPT_PREFIX="±‹%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

# clean_or_dirty
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"

# status
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[magenta]%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[blue]%➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[cyan]%}═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[green]%}✭"

# when ahead
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}!"

# short_sha
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$reset_color%}["
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}]"

local username="%{$fg_bold[green]%}%n%{$reset_color%}"
local hostname="%{$fg_bold[magenta]%}%m%{$reset_color%}"
local current_dir="$fg_bold[blue]%}%~%{$reset_color%}"

# Left prompt: username@hostname:current_directory%  
PROMPT='$username@$hostname:$current_dir%# '

# Right Prompt:  ±‹branch_name clean_or_dirty ahead [short_sha]status›
RPROMPT='$(git_prompt_info)$(git_prompt_ahead) $(git_prompt_short_sha)%{$reset_color%} $(git_prompt_status)%{$reset_color%}›'
