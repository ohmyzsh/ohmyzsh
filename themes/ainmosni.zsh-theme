# Theme with colour changing user and hostname.
#   by Daniël Franke <daniel [at] ams-sec [dot] org>
#
# Handy if you work on different servers all the time and want a different
# colourscheme when you're root and when you're on certain hosts.
#
# You can put this in your .zshrc to set your hostname red:
#   PRODUCTION_RE='^prod-'
# And for yellow:
#   STAGING_RE='^staging-'
# The contents are regular expression against which the host is matched,

# Default user colour
us_col=$fg[green]
# Make the user colour red if we're root.
if [[ `whoami` == 'root' ]]; then
    us_col=$fg[red]
fi

# Default host colour.
host_col=$fg[green]
local hostname=`hostname`

# Set the host colour red if it matches the production regex.
if [[ "$PRODUCTION_RE" != "" && "$hostname" =~ "$PRODUCTION_RE" ]]; then
    host_col=$fg[red]
# And yellow if it matches the staging regex.
elif [[ "$STAGING_RE" != "" && $hostname =~ $STAGING_RE ]]; then
    host_col=$fg[yellow]
fi

local start_angular="%{$fg_bold[white]%}[%{$reset_color%}"
local user_at_host="%{$us_col%}%n%{$reset_color%}%{$fg_bold[yellow]%}@%{$reset_color%}%{$host_col%}%m%{$reset_color%}"
local current_path="%{$fg[cyan]%}%2c%{$reset_color%}"
local end_angular="%{$fg_bold[white]%}]%{$reset_color%}"
local user_char="%{$us_col%}%(!.#.$)%{$reset_color%} "
local git_branch='$(git_prompt_status)%{$reset_color%}$(git_prompt_info)%{$reset_color%}'
local current_time="%{$fg_bold[magenta]%}(%D{%Y-%m-%d %H:%M})%{$reset_color%}"

PROMPT="${start_angular}${user_at_host}:${current_path}${end_angular}${user_char}"
RPROMPT="${git_branch}${current_time}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""


ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

