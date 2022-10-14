# source ~/Projects/zsh-custom/init.zsh
# backup for new installs..zshrc should be light
# export ZSH=$HOME/.oh-my-zsh
# export ZSH_CUSTOM=/Users/michaelwclark/Projects/zsh-custom/
# export ZSH_THEME="dallas"
# source $ZSH/oh-my-zsh.sh
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion



# Sync changes
git pull
git add .
git commit -m "update"
git push mine master

