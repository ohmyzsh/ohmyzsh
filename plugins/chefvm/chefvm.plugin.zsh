function knife_config {
  if [[ -e $HOME/.chefvm && -e $HOME/.chef ]] ; then
    echo $( cd -P $HOME/.chef ; basename $PWD )
  fi
}
