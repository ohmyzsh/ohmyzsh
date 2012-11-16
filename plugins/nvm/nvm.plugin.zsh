# NVM Wrapper

# Auto detect the NVM_DIR
if [ ! -d "$NVM_DIR" ]; then
  export NVM_DIR=~/.nvm
fi

. $ZSH/plugins/nvm/nvm.bash

if [ "$(autoload | grep bashcompinit)" = "" ]; then
  echo "hohoho"
  autoload -Uz bashcompinit
  bashcompinit
else
  echo "hehehe"
fi

. $ZSH/plugins/nvm/nvm_bash_completion

