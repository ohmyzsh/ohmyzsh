#!/bin/bash

brew update
brew upgrade
brew install `cat homebrew_packages.txt`

[ ! -f ~/.zshrc ]          && cp ~/.oh-my-zsh/templates/zshrc.zsh-template          ~/.zshrc
[ ! -f ~/.variables ]      && cp ~/.oh-my-zsh/templates/variables.zsh-template      ~/.variables
[ ! -f ~/.aliases ]        && cp ~/.oh-my-zsh/templates/aliases.zsh-template        ~/.aliases
[ ! -f ~/.secrets ]        && cp ~/.oh-my-zsh/templates/secrets.zsh-template        ~/.secrets
[ ! -f ~/.customizations ] && cp ~/.oh-my-zsh/templates/customizations.zsh-template ~/.customizations
[ ! -f ~/.gemrc]           && cp ~/.oh-my-zsh/templates/gemrc.zsh-template          ~/.gemrc

echo "/usr/local/bin/zsh" >> /etc/shells  # TODO grep to ensure that this line isn't there before appending it
chsh -s /usr/local/bin/zsh `whoami`
