if [[ -d ~/.oh-my-zsh ]]; then
  echo "Removing '~/.oh-my-zsh'";
  rm -rf ~/.oh-my-zsh;
else
  echo "Cannot find '~/.oh-my-zsh'";
  exit 1
fi

if [ -f ~/.zshrc.pre-oh-my-zsh ] || [ -h ~/.zshrc.pre-oh-my-zsh ]
then
  echo "Found '~/.zshrc.pre-oh-my-zsh', Restoring to ~/.zshrc";
  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc \
   || ( echo "cannot restore '~/.zshrc'!"; exit 2)
  source ~/.zshrc;
else
  echo "You might want to switch back to bash:";
  echo "chsh -s /bin/bash";
  echo "source /etc/profile";
fi

echo "Thanks for trying out 'Oh My Zsh', It is no longer installed.";

