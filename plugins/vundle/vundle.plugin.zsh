function vundle-init () {
<<<<<<< HEAD
  if [ ! -d ~/.vim/bundle/vundle/ ]
  then
    mkdir -p ~/.vim/bundle/vundle/
  fi

  if [ ! -d ~/.vim/bundle/vundle/.git ] && [ ! -f ~/.vim/bundle/vundle/.git ]
  then
    git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    echo "\n\tRead about vim configuration for vundle at https://github.com/gmarik/vundle\n"
=======
  if [ ! -d ~/.vim/bundle/Vundle.vim/ ]
  then
    mkdir -p ~/.vim/bundle/Vundle.vim/
  fi

  if [ ! -d ~/.vim/bundle/Vundle.vim/.git ] && [ ! -f ~/.vim/bundle/Vundle.vim/.git ]
  then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "\n\tRead about vim configuration for vundle at https://github.com/VundleVim/Vundle.vim\n"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  fi
}

function vundle () {
  vundle-init
<<<<<<< HEAD
  vim -c "execute \"PluginInstall\" | q | q"
=======
  vim -c "execute \"PluginInstall\" | qa"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

function vundle-update () {
  vundle-init
<<<<<<< HEAD
  vim -c "execute \"PluginInstall!\" | q | q"
=======
  vim -c "execute \"PluginInstall!\" | qa"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

function vundle-clean () {
  vundle-init
<<<<<<< HEAD
  vim -c "execute \"PluginClean!\" | q | q"
=======
  vim -c "execute \"PluginClean!\" | qa"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}
