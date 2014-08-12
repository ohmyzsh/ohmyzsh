function vundle-init () {
  if [ ! -d ~/.vim/bundle/Vundle.vim/ ]
  then
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "\n\tRead about vim configuration for vundle at https://github.com/gmarik/vundle\n"
  fi
}

function vundle () {
  vundle-init
  vim +PluginInstall +qall
  echo "\n\tVundle plugins installed!\n"
}

function vundle-update () {
  vundle-init
  vim +PluginUpdate +qall
  echo "\n\tVundle plugins updated!\n"
}

function vundle-clean () {
  vundle-init
  vim +PluginClean +qall
  echo "\n\tUnused vundle plugins has been removed!\n"
}
