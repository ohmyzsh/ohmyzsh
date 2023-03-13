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
cwd=$(pwd)

echo $THIS_CWD
cd ~/.oh-my-zsh
git pull >> /dev/null 
git add . >> /dev/null 
git commit -m "update" >> /dev/null 
git push mine >> /dev/null 
cd $cwd

bindkey "\e[1;3D" backward-word     # ⌥←
bindkey "\e[1;3C" forward-word      # ⌥→
bindkey "^[[1;9D" beginning-of-line # cmd+←
bindkey "^[[1;9C" end-of-line       # cmd+→
