# install.sh - oh-my-zsh installation script
#
# Respects these environment variables for tweaking the installation process:
#   REPO    - name of the GitHub repo to install from (default: robbyrussel/oh-my-zsh)
#   BRANCH  - branch to check out immediately after install
# These options are for use by oh-my-zsh developers, to facilitate testing of
# changes to the core oh-my-zsh installation code. Normal users should not set them.

set -e

if [ ! -n "$ZSH" ]; then
  ZSH=~/.oh-my-zsh
fi
if [ ! -n "$REPO" ]; then
  REPO=robbyrussell/oh-my-zsh
fi

if [ -d "$ZSH" ]; then
  echo "\033[0;33mYou already have Oh My Zsh installed.\033[0m You'll need to remove $ZSH if you want to install"
  exit
fi

echo "\033[0;34mCloning Oh My Zsh...\033[0m"
if [ -n "$BRANCH" ]; then
  BR_OPT="--branch $BRANCH"
fi
hash git >/dev/null 2>&1 && env git clone --depth=1 $BR_OPT https://github.com/$REPO.git $ZSH || {
  echo "git not installed"
  exit
}

echo "\033[0;34mLooking for an existing zsh config...\033[0m"
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
  echo "\033[0;33mFound ~/.zshrc.\033[0m \033[0;32mBacking up to ~/.zshrc.pre-oh-my-zsh\033[0m";
  mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
fi

echo "\033[0;34mUsing the Oh My Zsh template file and adding it to ~/.zshrc\033[0m"
cp $ZSH/templates/zshrc.zsh-template ~/.zshrc
sed -i -e "/^export ZSH=/ c\\
export ZSH=$ZSH
" ~/.zshrc

echo "\033[0;34mCopying your current PATH and adding it to the end of ~/.zshrc for you.\033[0m"
sed -i -e "/export PATH=/ c\\
export PATH=\"$PATH\"
" ~/.zshrc

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "\033[0;34mTime to change your default shell to zsh!\033[0m"
    chsh -s `which zsh`
fi

echo "\033[0;32m"'         __                                     __   '"\033[0m"
echo "\033[0;32m"'  ____  / /_     ____ ___  __  __   ____  _____/ /_  '"\033[0m"
echo "\033[0;32m"' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '"\033[0m"
echo "\033[0;32m"'/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '"\033[0m"
echo "\033[0;32m"'\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '"\033[0m"
echo "\033[0;32m"'                        /____/                       ....is now installed!'"\033[0m"
echo "\n\n \033[0;32mPlease look over the ~/.zshrc file to select plugins, themes, and options.\033[0m"
echo "\n\n \033[0;32mp.s. Follow us at http://twitter.com/ohmyzsh.\033[0m"
echo "\n\n \033[0;32mp.p.s. Get stickers and t-shirts at http://shop.planetargon.com.\033[0m"
env zsh
. ~/.zshrc
