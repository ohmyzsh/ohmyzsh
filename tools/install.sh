if [ -d ~/.oh-my-zsh ]
then
  echo -e "\033[0;33mYou already have Oh My Zsh installed.\033[0m You'll need to remove ~/.oh-my-zsh if you want to install";
  exit 1
fi

echo -e "\033[0;34mCloning Oh My Zsh...\033[0m"
/usr/bin/env git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
 || ( echo "Couldn't clone repository."; exit 2)

echo -e "\033[0;34mLooking for an existing zsh config...\033[0m"
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]
then
  echo -e "\033[0;33mFound ~/.zshrc.\033[0m \033[0;32]Backing up to ~/.zshrc.pre-oh-my-zsh\033[0m";
  cp -n ~/.zshrc ~/.zshrc.pre-oh-my-zsh && rm ~/.zshrc \
   || ( echo "Couldn't backup .zshrc!"; exit 3)
fi

echo -e "\033[0;34mUsing the Oh My Zsh template file and adding it to ~/.zshrc\033[0m"
cp -n ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc || exit 4

echo -e "\033[0;34mCopying your current PATH and adding it to the end of ~/.zshrc for you.\033[0m"
echo "export PATH=$PATH" >> ~/.zshrc;

echo -e "\033[0;34mYou might need to change your default shell to zsh:\033[0m"
echo "chsh -s $(which zsh)"

echo -e "\033[0;32m"'         __                                     __   '"\033[0m"
echo -e "\033[0;32m"'  ____  / /_     ____ ___  __  __   ____  _____/ /_  '"\033[0m"
echo -e "\033[0;32m"' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '"\033[0m"
echo -e "\033[0;32m"'/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '"\033[0m"
echo -e "\033[0;32m"'\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '"\033[0m"
echo -e "\033[0;32m"'                        /____/                       '"\033[0m"

echo -e "\n\n \033[0;32m....is now installed.\033[0m"
/usr/bin/env zsh && source ~/.zshrc;
