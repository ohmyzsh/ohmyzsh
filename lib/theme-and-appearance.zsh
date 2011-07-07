# Load and run colors.
autoload -U colors
colors -i

# Set the GNU Screen window number.
if [[ -n "$WINDOW" ]]; then
  SCREEN_NO="%B$WINDOW%b "
else
  SCREEN_NO=""
fi

# Set the default prompt theme.
PS1="%n@%m:%~%# "

# Set the default Git prompt theme.
ZSH_THEME_GIT_PROMPT_PREFIX="git:("    # Prefix before the branch name.
ZSH_THEME_GIT_PROMPT_SUFFIX=")"        # Suffix after the branch name.
ZSH_THEME_GIT_PROMPT_DIRTY="*"         # Indicator to display if the branch is dirty.
ZSH_THEME_GIT_PROMPT_CLEAN=""          # Indicator to display if the branch is clean.

# Enable parameter, arithmentic expansion and command substitution in prompt.
setopt prompt_subst

