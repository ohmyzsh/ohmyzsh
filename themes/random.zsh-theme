# Deprecate ZSH_THEME_RANDOM_BLACKLIST
if [[ -n "$ZSH_THEME_RANDOM_BLACKLIST" ]]; then
  echo '[oh-my-zsh] ZSH_THEME_RANDOM_BLACKLIST is deprecated. Use `ZSH_THEME_RANDOM_IGNORED` instead.'
  ZSH_THEME_RANDOM_IGNORED=($ZSH_THEME_RANDOM_BLACKLIST)
  unset ZSH_THEME_RANDOM_BLACKLIST
fi

# Make themes a unique array
typeset -Ua themes

if [[ "${(t)ZSH_THEME_RANDOM_CANDIDATES}" = array && ${#ZSH_THEME_RANDOM_CANDIDATES[@]} -gt 0 ]]; then
  # Use ZSH_THEME_RANDOM_CANDIDATES if properly defined
  themes=(${(@)ZSH_THEME_RANDOM_CANDIDATES:#random})
else
  # Look for themes in $ZSH_CUSTOM and $ZSH and add only the theme name
  themes=(
    "$ZSH_CUSTOM"/*.zsh-theme(N:t:r)
    "$ZSH_CUSTOM"/themes/*.zsh-theme(N:t:r)
    "$ZSH"/themes/*.zsh-theme(N:t:r)
  )
  # Remove ignored themes from the list
  for theme in random ${ZSH_THEME_RANDOM_IGNORED[@]}; do
    themes=("${(@)themes:#$theme}")
  done
fi

# Choose a theme out of the pool of candidates
N=${#themes[@]}
(( N = (RANDOM%N) + 1 ))
RANDOM_THEME="${themes[$N]}"
unset N themes theme

# Source theme
if [[ -f "$ZSH_CUSTOM/$RANDOM_THEME.zsh-theme" ]]; then
  source "$ZSH_CUSTOM/$RANDOM_THEME.zsh-theme"
elif [[ -f "$ZSH_CUSTOM/themes/$RANDOM_THEME.zsh-theme" ]]; then
  source "$ZSH_CUSTOM/themes/$RANDOM_THEME.zsh-theme"
elif [[ -f "$ZSH/themes/$RANDOM_THEME.zsh-theme" ]]; then
  source "$ZSH/themes/$RANDOM_THEME.zsh-theme"
else
  echo "[oh-my-zsh] Random theme '${RANDOM_THEME}' not found"
  return 1
fi

if [[ -z "$ZSH_THEME_RANDOM_QUIET" ]]; then
  echo "[oh-my-zsh] Random theme '${RANDOM_THEME}' loaded"
fi
