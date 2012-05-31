# ebouchut ZSH Theme
# http://img638.imageshack.us/img638/5069/b2f.png
#
# Left Prompt:
#   username@hostname:current_directory%  
#
# Right prompt when in a Git repository:
#      ±‹branch_name clean_or_dirty› status(ahead) [short_sha]
# 
# author: Eric Bouchut

ZSH_THEME_GIT_PROMPT_PREFIX="±‹%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}› "

# clean_or_dirty
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"

# status
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[magenta]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[blue]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[cyan]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[green]%}✭%{$reset_color%}"

# when ahead
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}(!)%{$reset_color%}"

# short_sha
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$reset_color%}["
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}]"

local username="%{$fg_bold[green]%}%n%{$reset_color%}"
local hostname="%{$fg_bold[magenta]%}%m%{$reset_color%}"
local current_dir="%{$fg_bold[blue]%}%~%{$reset_color%}"
local cmd_status="%(?,%{$fg_bold[green]%}☺%{$reset_color%},%{$fg_bold[red]%}☹%{$reset_color%})"


# Left prompt: username@hostname:current_directory
PROMPT='
$username@$hostname:$current_dir 
${cmd_status} '


# Right prompt when in a git repo:  rvm_config ±‹branch_name clean_or_dirty› status(ahead) [short_sha]
RPROMPT='$(~/.rvm/bin/rvm-prompt) $(git_prompt_info)$(git_prompt_status)$(git_prompt_ahead)$(git_prompt_short_sha)'
