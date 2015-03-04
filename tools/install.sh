set -e

BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NOCOLOR="\033[0m"

if [ ! -n "$ZSH" ]; then
  ZSH=~/.oh-my-zsh
fi

if [ -d "$ZSH" ]; then
  printf "${YELLOW}You already have Oh My Zsh installed.${NOCOLOR} You'll need to remove $ZSH if you want to install\n"
  exit
fi

printf "${BLUE}Cloning Oh My Zsh...${NOCOLOR}\n"
hash git >/dev/null 2>&1 && env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH || {
  printf "git not installed\n"
  exit
}

printf "${BLUE}Looking for an existing zsh config...${NOCOLOR}\n"
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
  printf "${YELLOW}Found ~/.zshrc.${NOCOLOR} ${GREEN}Backing up to ~/.zshrc.pre-oh-my-zsh${NOCOLOR}\n";
  mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
fi

printf "${BLUE}Using the Oh My Zsh template file and adding it to ~/.zshrc${NOCOLOR}\n"
cp $ZSH/templates/zshrc.zsh-template ~/.zshrc
sed -i -e "/^export ZSH=/ c\\
export ZSH=$ZSH
" ~/.zshrc

printf "${BLUE}Copying your current PATH and adding it to the end of ~/.zshrc for you.${NOCOLOR}\n"
sed -i -e "/export PATH=/ c\\
export PATH=\"$PATH\"
" ~/.zshrc

TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    printf "${BLUE}Time to change your default shell to zsh!${NOCOLOR}\n"
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
echo 'p.s. Follow us at http://twitter.com/ohmyzsh.'
echo ''
echo 'p.p.s. Get stickers and t-shirts at http://shop.planetargon.com.'
echo ''
printf "${NOCOLOR}"
env zsh
