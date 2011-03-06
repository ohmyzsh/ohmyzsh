echo "Removing Oh My Zsh"
if [[ -d ~/.oh-my-zsh ]]
then
  rm -rf ~/.oh-my-zsh
fi

echo "Looking for a previous zsh config..."
if [ -f ~/.zshrc.pre-oh-my-zsh ] || [ -h ~/.zshrc.pre-oh-my-zsh ]
then
  echo "File found! Moving it back in place";
  rm ~/.zshrc;
  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc;
  source ~/.zshrc;
else
  echo "File not found. Switching back to bash"
  chsh -s /bin/bash
  source /etc/profile
fi

echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
