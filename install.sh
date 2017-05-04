#!/bin/bash

PWD=$(pwd)
echo $PWD
ln -s ${PWD} ~/.oh-my-zsh
ln -s ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

