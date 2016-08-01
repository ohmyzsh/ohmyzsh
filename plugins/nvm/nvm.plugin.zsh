# The addition 'nvm install' attempts in ~/.profile

if [ -f $HOME/.nvm/nvm.sh ]; then # manual user-local installation
  . ~/.nvm/nvm.sh
elif [ $commands[brew] -a -f `brew --prefix`/opt/nvm/nvm.sh ]; then # mac os x with brew
  . $(brew --prefix)/opt/nvm/nvm.sh
fi
