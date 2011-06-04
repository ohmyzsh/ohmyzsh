RESET="\033[0m"
RED="\033[0;31m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
UNDERLN="\033[4m"
current_path=`pwd`
echo "${BLUE}Upgrading Oh My Zsh${RESET}"
( cd $ZSH && git pull origin master )
echo "${GREEN}"'         __                                     __   '"${RESET}"
echo "${GREEN}"'  ____  / /_     ____ ___  __  __   ____  _____/ /_  '"${RESET}"
echo "${GREEN}"' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '"${RESET}"
echo "${GREEN}"'/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '"${RESET}"
echo "${GREEN}"'\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '"${RESET}"
echo "${GREEN}"'                        /____/                       '"${RESET}"
echo "${BLUE}Hooray! Oh My Zsh has been updated and/or is at the latest version.${RESET}"
echo "${BLUE}To keep up on the latest, be sure to follow Oh My Zsh on twitter: ${UNDERLN}http://twitter.com/ohmyzsh${RESET}"
cd $current_path
