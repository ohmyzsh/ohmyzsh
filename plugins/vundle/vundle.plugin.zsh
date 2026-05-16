function vundle-init () {
  if [ ! -d ~/.vim/bundle/Vundle.vim/ ]
  then
    mkdir -p ~/.vim/bundle/Vundle.vim/
  fi

  if [ ! -d ~/.vim/bundle/Vundle.vim/.git ] && [ ! -f ~/.vim/bundle/Vundle.vim/.git ]
  then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "\n\tRead about vim configuration for vundle at https://github.com/VundleVim/Vundle.vim\n"
  fi
}

function vundle () {
  vundle-init
  vim -c "execute \"PluginInstall\" | qa"
}

function vundle-update () {
  vundle-init
  vim -c "execute \"PluginInstall!\" | qa"
}

function vundle-clean () {
  vundle-init
  vim -c "execute \"PluginClean!\" | qa"
}
