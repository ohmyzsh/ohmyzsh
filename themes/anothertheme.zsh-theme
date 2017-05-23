# Name      : Another (simple zsh) theme
# Author    : Thomas VIAL
# URL       : http://tvi.al

# The prompt looks like this:
# [12:34:56] user@hostname:/path/to/project [git:branch-name*] $

# Installation:
# In your .zshrc file, edit:
# ZSH_THEME="anothertheme"

# You can change ANOTHERTHEME_USERHOSTNAME_COLOR and ANOTHERTHEME_PATH_COLOR from your .zshrc file.
# It could be useful to set a color per server to avoid mistakes when you have multiple shells open.
# In your .zshrc (do not modifiy the theme)
# ANOTHERTHEME_USERHOSTNAME_COLOR="blue"
# ANOTHERTHEME_PATH_COLOR="green"

#
# Do not edit the next part
#

[[ -z "$ANOTHERTHEME_USERHOSTNAME_COLOR" ]] && ANOTHERTHEME_USERHOSTNAME_COLOR="blue"
[[ -z "$ANOTHERTHEME_PATH_COLOR" ]] && ANOTHERTHEME_PATH_COLOR="green"

PROMPT='[%*] %{$fg[$ANOTHERTHEME_USERHOSTNAME_COLOR]%}%n@%m%{$reset_color%}:%{$fg[$ANOTHERTHEME_PATH_COLOR]%}%/%{$reset_color%}$(git_prompt_info) %(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"

