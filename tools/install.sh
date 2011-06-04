RESET="\033[0m"
RED="\033[0;31m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
UNDERLN="\033[4m"
if [ -d ~/.oh-my-zsh ]
then
  echo "${YELLOW}You already have Oh My Zsh installed.${RESET} You'll need to remove ~/.oh-my-zsh if you want to install"
  exit
fi

echo "${BLUE}Cloning Oh My Zsh...${RESET}"
/usr/bin/env git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

echo "${BLUE}Looking for an existing zsh config...${RESET}"
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]
then
  echo "${YELLOW}Found ~/.zshrc.${RESET} ${GREEN}Backing up to ~/.zshrc.pre-oh-my-zsh${RESET}"
  cp ~/.zshrc ~/.zshrc.pre-oh-my-zsh
  rm ~/.zshrc
fi

echo "${BLUE}Using the Oh My Zsh template file and adding it to ~/.zshrc${RESET}"
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

echo "${BLUE}Copying your current PATH and adding it to the end of ~/.zshrc for you.${RESET}"
echo "export PATH=$PATH" >> ~/.zshrc

echo "${BLUE}Time to change your default shell to zsh!${RESET}"
chsh -s `which zsh`

echo "${GREEN}"'         __                                     __   '"${RESET}"
echo "${GREEN}"'  ____  / /_     ____ ___  __  __   ____  _____/ /_  '"${RESET}"
echo "${GREEN}"' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '"${RESET}"
echo "${GREEN}"'/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '"${RESET}"
echo "${GREEN}"'\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '"${RESET}"
echo "${GREEN}"'                        /____/                       '"${RESET}"

echo "\n\n ${GREEN}....is now installed.${RESET}"
/usr/bin/env zsh
source ~/.zshrc
