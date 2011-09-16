
 ##################
  # uninstall.sh #
 ##################

source ./common
proclaim 'Uninstalling Oh-My-Zsh'

if [[ -d ~/.oh-my-zsh ]]; then
  changes=`diff --unchanged-group-format='' --suppress-common-lines ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc`
  changes=`echo "$changes" | grep -v "^export PATH=$PATH$"`
  if [ ! -z "$changes" ]; then
    info 'Appending changes to ~/.zshrc to ~/.zshrc.changes:'
    text "$changes"
    echo "$changes" >> ~/.zshrc.changes \
     || ( warn 'Cannot append to ~/.zshrc.changes!'; exit 1 )
  fi
  info 'Removing ~/.zshrc'
  rm ~/.zshrc
  info 'Removing ~/.oh-my-zsh'
  rm -rf ~/.oh-my-zsh;
else
  warn 'Cannot find ~/.oh-my-zsh'
  exit 2
fi

if [ -f ~/.zshrc.pre-oh-my-zsh ] || [ -h ~/.zshrc.pre-oh-my-zsh ]
then
  info 'Found ~/.zshrc.pre-oh-my-zsh, Restoring to ~/.zshrc'
  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc \
   || ( warn 'Cannot restore ~/.zshrc!'; exit 3 )
  source ~/.zshrc;
else
  note 'You might want to switch back to bash:'
  shell_example \
   'chsh -s /bin/bash' \
   'source /etc/profile'
fi

proclaim 'Thanks for trying out \47Oh My Zsh\47, It is no longer installed'

