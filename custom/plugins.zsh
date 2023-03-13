PLUGINS_DIR=$ZSH/plugins
source $PLUGINS_DIR/git/git.plugin.zsh
source $PLUGINS_DIR/z/z.plugin.zsh

if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
# Take action if $DIR exists. #
echo "Installing zsh autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
  source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
fi


eval "$(gh completion -s zsh)"
