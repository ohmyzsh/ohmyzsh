if [[ "${(t)ZSH_THEME_RANDOM_CANDIDATES}" = "array" ]] && [[ "${#ZSH_THEME_RANDOM_CANDIDATES[@]}" -gt 0 ]]; then
  themes=($ZSH/themes/${^ZSH_THEME_RANDOM_CANDIDATES}.zsh-theme)
else
  themes=($ZSH/themes/*zsh-theme)
fi
N=${#themes[@]}
((N=(RANDOM%N)+1))
RANDOM_THEME=${themes[$N]}
source "$RANDOM_THEME"
echo "[oh-my-zsh] Random theme '$RANDOM_THEME' loaded..."
