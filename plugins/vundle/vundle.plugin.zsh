function vundle-init () {
  if [ ! -d ~/.vim/bundle/Vundle.vim/ ]
  then
    mkdir -p ~/.vim/bundle/Vundle.vim/
  fi

  if [ ! -d ~/.vim/bundle/Vundle.vim/.git ] && [ ! -f ~/.vim/bundle/Vundle.vim/.git ]
  then
    git clone http://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "\n\tRead about vim configuration for vundle at https://github.com/gmarik/Vundle.vim\n"
  fi
}

function vundle () {
  vundle-init
  vim +PluginInstall +qall
}

function vundle-update () {
  vundle-init
  vim +PluginUpdate +qall
}

function vundle-clean () {
  vundle-init
  vim +PluginClean +qall
}
