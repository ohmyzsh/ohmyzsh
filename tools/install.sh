if [ -d ~/.oh-my-zsh ]
then
  echo "You already have Oh My Zsh installed. You'll need to remove ~/.oh-my-zsh if you want to install"
  exit
else
  echo "Cloning Oh My Zsh..."
  /usr/bin/env git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

echo "Looking for an existing zsh config..."
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]
then
  echo "Found ~/.zshrc. Backing up to ~/.zshrc.pre-oh-my-zsh";
  cp ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
  rm ~/.zshrc;
fi

echo "Symlinking .zshrc to ~/.oh-my-zsh/"
ln -s ~/.oh-my-zsh/zshrc ~/.zshrc

echo "Time to change your default shell to zsh!"
chsh -s /bin/zsh

echo "Hooray! Oh My Zsh has been installed."
/bin/zsh
source ~/.zshrc

