
# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

printf "${BLUE}%s${NORMAL}\n" "Updating Oh My Zsh"
cd "$ZSH"
if git pull --rebase --stat origin master
then
  printf '%s' "$GREEN"
  printf '%s\n' ' _ __  _  ___ ___  ___  ___  _ __ ___  _ __ ___  _ '
  printf '%s\n' "|  _ \| |/ __/ _ \/ __|/ _ \|  _   _ \| \ _  _ \| |"
  printf '%s\n' "| | | | | (_| (_) \__ \ (_) | | | | | | | | | | | |"
  printf '%s\n' "|_| |_|_|\___\___/|___/\___/|_| |_| |_|_| |_| |_|_|"
  printf "${BLUE}%s\n" "Hooray! Oh My custom Zsh has been updated and/or is at the current version."
else
  printf "${RED}%s${NORMAL}\n" 'There was an error updating. Try again later?'
fi
