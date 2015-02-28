#!/usr/bin/env zsh

echo "Removing $ZSH"
if [[ -d $ZSH ]]; then
  rm -rf $ZSH
fi

echo "Removing Oh My Zsh data files"
if [[ -z $SHORT_HOST ]]; then
  SHORT_HOST=${HOST/.*/}
fi
setopt null_glob
rm -fv ~/.zsh-update ~/.zshrc-e ${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-*


echo "Looking for original zsh config..."
if [ -f ~/.zshrc.pre-oh-my-zsh ] || [ -h ~/.zshrc.pre-oh-my-zsh ]; then
  echo "Found ~/.zshrc.pre-oh-my-zsh -- Restoring to ~/.zshrc";

  if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
    ZSHRC_SAVE=".zshrc.omz-uninstalled-`date +%Y%m%d%H%M%S`";
    echo "Found ~/.zshrc -- Renaming to ~/${ZSHRC_SAVE}";
    mv ~/.zshrc ~/${ZSHRC_SAVE};
  fi

  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc;

else
  echo "Switching back to bash"
  chsh -s /bin/bash
fi

echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
