# Aliases in this file are bash and zsh compatible

ohmyzsh=$HOME/.oh-my-zsh

gcohistory() {
  i=0
  while [ $? -eq 0 ]; do
    i=$((i+1))
    echo -n "$i. "
    git rev-parse --symbolic-full-name @{-$i} 2> /dev/null
  done
}

# Get operating system
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
  platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
  platform='darwin'
fi

# PS
alias psa="ps aux"
alias psg="ps aux | grep "

# Moving around
alias cdb='cd -'
alias cls='clear;ls'

# Show human friendly numbers and colors
alias df='df -h'
alias du='du -h -d 2'

if [[ $platform == 'darwin' ]]; then
  alias meld='/Applications/Meld.app/Contents/MacOS/Meld'
  alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'
  # Homebrew
  alias brewu='brew update && brew upgrade && brew cleanup && brew doctor'
fi

# Alias Editing
TRAPHUP() {
  source $ohmyzsh/custom/aliases.zsh
}

alias ae='vi $ohmyzsh/custom/aliases.zsh'         #alias edit
alias arl='source $oh-my-zsh/custom/aliases.zsh'  #alias reload
alias gar="killall -HUP -u \"$USER\" zsh"         #global alias reload

# git
alias gs='git status -uno'

# vim using
mvim --version > /dev/null 2>&1
MACVIM_INSTALLED=$?
if [ $MACVIM_INSTALLED -eq 0 ]; then
  alias vim="mvim -v"
fi

# mimic vim functions
alias :q='exit'

# vimrc editing
alias ve='vi ~/.vimrc'

# exa vs. ls
if [ ! "$MSYSTEM" = "MINGW64" ]; then
  alias ls='exa'
  alias la='ll -a'
fi

# git
alias gcoh="gcohistory"
alias gld="git log --pretty=format:'%C(yellow)%h%C(reset) - %an [%C(green)%ar%C(reset)] %s'"
alias glsi='git ls-files --other --ignored --exclude-standard'
alias galiases='git config -l | grep alias | cut -c 7-'
alias gls='git log --stat --decorate --source -p'
alias glhistg="git log --graph --pretty=format:'%C(yellow)%h%C(bold white red)%d%Creset %s %C(bold green)%cr %Creset%C(white)%an' --abbrev-commit --date=relative"
alias gdmb='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gdtree='git diff-tree'

