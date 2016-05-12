_homebrew-installed() {
  type brew &> /dev/null
}

_nvm-from-homebrew-installed() {
  brew --prefix nvm &> /dev/null
}

FOUND_NVM=0
nvmdirs=("$HOME/.nvm" "/usr/local/nvm" "/opt/nvm" "/usr/local/opt/nvm")
if _homebrew-installed && _nvm-from-homebrew-installed ; then
    nvmdirs=($(brew --prefix nvm) "${rbenvdirs[@]}")
fi

for nvmdir in "${nvmdirs[@]}" ; do
  if [ -s $nvmdir/nvm.sh -a $FOUND_NVM -eq 0 ]; then
    FOUND_NVM=1
    if [[ $NVM_DIR = '' ]]; then
      NVM_DIR=$nvmdir
    fi
    export NVM_DIR
    source $nvmdir/nvm.sh
  fi
done
unset nvmdir
