RESET="\033[0m"
RED="\033[0;31m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
UNDERLN="\033[4m"
echo "${RED}Removing ~/.oh-my-zsh${RESET}"
if [[ -d ~/.oh-my-zsh ]]
then
  rm -rf ~/.oh-my-zsh
fi

echo "${BLUE}Looking for an existing zsh config...${RESET}"
if [ -f ~/.zshrc.pre-oh-my-zsh ] || [ -h ~/.zshrc.pre-oh-my-zsh ]
then
  echo "${YELLOW}Found ~/.zshrc.pre-oh-my-zsh.${RESET} ${GREEN}Restoring to ~/.zshrc${RESET}"
  rm ~/.zshrc
  cp ~/.zshrc.pre-oh-my-zsh ~/.zshrc
  source ~/.zshrc
else
  echo "${BLUE}Switching back to bash${RESET}"
  chsh -s /bin/bash
  source /etc/profile
fi

echo "${GREEN}Thanks for trying out Oh My Zsh. It has been uninstalled.${RESET}"
