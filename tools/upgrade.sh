
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

STASH_NAME="STASH BEFORE UPDATING"

cd "$ZSH"

if [ -n "$(git status --untracked-files=no --porcelain)" ]; then
  # Working directory clean excluding untracked files
  printf "${YELLOW}%s${NORMAL}\n" "Found untracked files, automatically stash for you."
  git stash save "${STASH_NAME}" >/dev/null
fi

printf "${BLUE}%s${NORMAL}\n" "Updating Oh My Zsh"

if git pull --rebase --stat origin master
then
  printf '%s' "$GREEN"
  printf '%s\n' '         __                                     __   '
  printf '%s\n' '  ____  / /_     ____ ___  __  __   ____  _____/ /_  '
  printf '%s\n' ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
  printf '%s\n' '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
  printf '%s\n' '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
  printf '%s\n' '                        /____/                       '

  if [ -n "$(git stash list | grep "${STASH_NAME}")" ]; then
    printf "${YELLOW}%s${NORMAL}\n" "Automatically pop untracked files for you."
    git stash pop >/dev/null
  fi
  
  printf "${BLUE}%s\n" "Hooray! Oh My Zsh has been updated and/or is at the current version."
  printf "${BLUE}${BOLD}%s${NORMAL}\n" "To keep up on the latest news and updates, follow us on twitter: https://twitter.com/ohmyzsh"
  printf "${BLUE}${BOLD}%s${NORMAL}\n" "Get your Oh My Zsh swag at:  https://shop.planetargon.com/"
else
  printf "${RED}%s${NORMAL}\n" 'There was an error updating. Try again later?'
fi

