set -e

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
ncolors=$(tput colors)
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
CHECK_ZSH_INSTALLED=$(grep /zsh$ /etc/shells | wc -l)
if [ ! $CHECK_ZSH_INSTALLED -ge 1 ]; then
  echo "${YELLOW}Zsh is not installed!${NORMAL} Please install zsh first!"
  exit
fi
unset CHECK_ZSH_INSTALLED

if [ ! -n "$ZSH" ]; then
  ZSH=~/.oh-my-zsh
fi

if [ -d "$ZSH" ]; then
  printf "${YELLOW}You already have Oh My Zsh installed.${NORMAL}\n"
  printf "You'll need to remove $ZSH if you want to re-install.\n"
  exit
fi

printf "${BLUE}Cloning Oh My Zsh...${NORMAL}\n"
hash git >/dev/null 2>&1 && env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH || {
  printf "git not installed\n"
  exit
}

printf "${BLUE}Looking for an existing zsh config...${NORMAL}\n"
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
  printf "${YELLOW}Found ~/.zshrc.${NORMAL} ${GREEN}Backing up to ~/.zshrc.pre-oh-my-zsh${NORMAL}\n";
  mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
fi

printf "${BLUE}Using the Oh My Zsh template file and adding it to ~/.zshrc${NORMAL}\n"
cp $ZSH/templates/zshrc.zsh-template ~/.zshrc
sed "/^export ZSH=/ c\\
export ZSH=$ZSH
" ~/.zshrc > ~/.zshrc-omztemp
mv -f ~/.zshrc-omztemp ~/.zshrc

printf "${BLUE}Copying your current PATH and adding it to the end of ~/.zshrc for you.${NORMAL}\n"
sed "/export PATH=/ c\\
export PATH=\"$PATH\"
" ~/.zshrc > ~/.zshrc-omztemp
mv -f ~/.zshrc-omztemp ~/.zshrc

TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    printf "${BLUE}Time to change your default shell to zsh!${NORMAL}\n"
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
fi
unset TEST_CURRENT_SHELL

printf "${GREEN}"
echo '         __                                     __   '
echo '  ____  / /_     ____ ___  __  __   ____  _____/ /_  '
echo ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
echo '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
echo '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
echo '                        /____/                       ....is now installed!'
echo ''
echo ''
echo 'Please look over the ~/.zshrc file to select plugins, themes, and options.'
echo ''
echo 'p.s. Follow us at https://twitter.com/ohmyzsh.'
echo ''
echo 'p.p.s. Get stickers and t-shirts at http://shop.planetargon.com.'
echo ''
printf "${NORMAL}"
env zsh
