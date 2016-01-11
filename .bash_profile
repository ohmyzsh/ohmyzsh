# call .bashrc file
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi

##
export DYLD_LIBRARY_PATH=/usr/lib/:$DYLD_LIBRARY_PATH
# MacPorts Installer addition on 2014-03-23_at_23:01:41: adding an appropriate PATH variable for use with MacPorts.
export PATH=/usr/local/bin:PATH:/opt/local/bin:/opt/local/sbin:$PATH
GRADLE_HOME=/Users/sli/Documents/gradle-2.0
export PATH=$PATH:$GRADLE_HOME/bin
# Finished adapting your PATH environment variable for use with MacPorts.

# change prompt display style

# grep
alias grep='grep --color=always'

# so that git log could support Chinese
export LESSCHARSET=utf-8

# system alias tweek
# alias agi='sudo apt-get install'
alias vim="/Applications/MacVim.app/Contents/MacOS/vim"
alias l="ls -l"
alias ll="ls -al"
alias ls="ls -lart"
alias c="clear"
alias cl="clear"

alias d="cd ~/Desktop"
alias wr="cd ~/Dropbox/UTK/Papers"
alias p="cd ~/Dropbox/Projects/mousepotato.github.io/_posts/"
alias na="cd ~/Dropbox/Projects/narcissus/"
alias aq="cd ~/Dropbox/Projects/Aqoin_project/sli-whs/"
alias di="cd ~/Dropbox/UTK/Papers/dissertation/"

alias e="exit"
alias eb='vim ~/.bash_profile'
alias sb='source $HOME/.bash_profile 1>/dev/null'
alias clear='printf "\ec"' #clear terminal and empty scrollback
alias myip='curl ifconfig\.me/ip'
alias ssh11='ssh sli22@hydra11.eecs.utk.edu'
alias sshaq='ssh -p 8822 root@fhs.im'

alias gc="git clone"
alias gpm="git push origin master"
alias ga="git add ."
alias gs="git status"
# use function to pass argument for git commit -m
alias gm="git commit -m $1"
function gm(){
    git commit -m $1;
}

# for jekyll

alias jb="jekyll build"
alias js="jekyll server"

# start mongoDB

alias mos="mongod --dbpath ~/Documents/mongoDB/data"
alias mg="mongo"


# for gradle
alias gb='gradle build'
alias ge='gradle eclipse'

alias vrc="vim ~/.dotfiles/vim/vim_runtime/my_configs.vim"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
