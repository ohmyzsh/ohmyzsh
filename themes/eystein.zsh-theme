# Grab the current filepath, use shortcuts: ~/Desktop
# Append the current git branch, if in a git repository
#
# %n is username
# %m is servername
# %c is path

# Simple Prompt
EYSTEIN_CURRENT_LOCA_="%{$fg_bold[cyan]%}%~\$(git_prompt_info)%{$reset_color%}"

# Prompt with user
#EYSTEIN_CURRENT_LOCA_='[%{$fg_bold[blue]%}%n@%m%{$reset_color%} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)%{$reset_color%}]$ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%} <%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[white]%}"

# Do nothing if the branch is clean (no changes).
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%}>"

# Add a yellow ✗ if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}> %{$fg[yellow]%}✗"

# Put it all together!
PROMPT="$EYSTEIN_CURRENT_LOCA_ "
