themes=($ZSH/themes/*zsh-theme)
N=${#themes[@]}
((N=(RANDOM%N)+1))
RANDOM_THEME=${themes[$N]}
source "$RANDOM_THEME"
echo "[oh-my-zsh] Random theme '$RANDOM_THEME' loaded..."
