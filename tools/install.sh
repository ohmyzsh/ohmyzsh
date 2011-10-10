
 ################
  # install.sh #
 ################

source ./common

if [ -d ~/.oh-my-zsh ]
then
  proclaim 'You already have Oh My Zsh installed'
  note 'You\47ll need to remove ~/.oh-my-zsh if you want to install'
  exit 1
fi

proclaim 'Installing Oh-My-Zsh'
info 'Cloning Oh My Zsh...'
/usr/bin/env git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
 || ( warn 'Couldn\47t clone repository.'; exit 2)

info 'Looking for an existing zsh config...'
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]
then
  info 'Found ~/.zshrc.'
  info 'Backing up to ~/.zshrc.pre-oh-my-zsh'
  cp -n ~/.zshrc ~/.zshrc.pre-oh-my-zsh && rm ~/.zshrc \
   || ( warn 'Couldn\47t backup .zshrc!'; exit 3)
fi

info 'Using the Oh My Zsh template file and adding it to ~/.zshrc'
cp -n ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc || exit 4

info 'Copying your current PATH and adding it to the end of ~/.zshrc for you.'
echo "export PATH=$PATH" >> ~/.zshrc

note 'You might need to change your default shell to zsh:'
shell_example 'chsh -s $(which zsh)'

proclaim '         __                                     __   '
proclaim '  ____  / /_     ____ ___  __  __   ____  _____/ /_  '
proclaim ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
proclaim '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
proclaim '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
proclaim '                        /____/                       '
proclaim '                                    is now installed.'

/usr/bin/env zsh && source ~/.zshrc;

