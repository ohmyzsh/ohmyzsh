function vundle-init () {
  if [ ! -d ~/.vim/bundle/vundle/ ]
  then
    mkdir -p ~/.vim/bundle/vundle/
  fi

  if [ ! -d ~/.vim/bundle/vundle/.git/ ]
  then
    git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  fi
}

function vundle () {
  vundle-init
  vim -c "execute \"BundleInstall\" | q"
}


function vundle-update () {
  vundle-init
  vim -c "execute \"BundleInstall!\" | q"
}
