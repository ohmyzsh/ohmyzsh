# ezzsh - zshrc

# load zpython
# module_path=($module_path /usr/local/lib/zpython)
# zmodload zsh/zpython

# plugins to load (array)
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=(git command-not-found)
plugins=(git)

# export ZSH_THEME="random"
# export ZSH_THEME="ezzsh" # name of zsh theme
# export ZSH_THEME="powerline" # name of zsh theme
export ZSH_THEME="powerline-with-hostname" # name of zsh theme

if [[ "$TERM" == "linux" ]]; then
  export ZSH_THEME=ezzsh
fi

# Set this to true to use case-sensitive completion
CASE_SENSITIVE="false" # bool

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true" # bool

# Uncomment following line if you want to disable colors in ls
DISABLE_LS_COLORS="false" # bool

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="false" # bool

# Uncomment following line if you want disable red dots displayed while waiting for completion
DISABLE_COMPLETION_WAITING_DOTS="false" # bool

# path to your zsh configuration.
ZSH="$HOME/.zsh"

# Customize to your needs...
source $ZSH/zsh

# workaround for broken xfce4 terminal to force $TERM:
if [[ "$COLORTERM" == "xfce4-terminal" ]]; then
    export TERM="xterm-256color"
fi

# workaround for rxvt
if [[ "$COLORTERM" == "rxvt-xpm" ]]; then
    export TERM="rxvt-unicode-256color"
fi

# set $OS_TYPE
export OS_TYPE="$(uname)"

# $ZSH - Path to your zsh installation.
export ZSH=$HOME/.zsh/

# modify $PATH
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH

# set $EDITOR
export EDITOR='vim'

# colors in man pages
# export LESS_TERMCAP_mb=$'\E[01;31m'
# export LESS_TERMCAP_md=$'\E[01;33m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
# export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
# export LESS_TERMCAP_us=$'\E[01;32m'
export LESS_TERMCAP_mb=$'[38;5;171;01m'
export LESS_TERMCAP_md=$'[38;5;81;01m'
export LESS_TERMCAP_so=$'[38;5;80;01m'
export LESS_TERMCAP_us=$'[38;5;214;01m'

# small zsh hack to fix ssh host completion from ~/.ssh/config
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}

# needed to keep backgrounded jobs running when exiting zsh:
setopt NO_HUP

# homebrew githup api token file to source, if any
# needs to set HOMEBREW_GITHUB_API_TOKEN=...
if [[ -e ~/.homebrew-github-api-token ]]; then
  source ~/.homebrew-github-api-token
fi

# mosh title
# export MOSH_TITLE_NOPREFIX=1

# jump/mark/unmark/marks stuff (make sure to load the "jump" plugin in plugins=() )
function _completemarks {
  reply=($(ls $MARKPATH))
}
compctl -K _completemarks jump
compctl -K _completemarks unmark

# force english locales
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# set custom ls options
LS_OPTIONS="--color=auto --group-directories-first -F"

# Mac OS X specific stuff:
if [[ "$OS_TYPE" == "Darwin" ]]; then
  # preceed path with homebrew stuff:
  export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
  # ipython on mac:
  alias ipython='/Users/armin/git/ipython/bin/ipython'
  # homebrew verbosity / emoji icon removal:
  export HOMEBREW_VERBOSE=1
  export HOMEBREW_CURL_VERBOSE=1
  export HOMEBREW_NO_EMOJI=1
  if hash gls >/dev/null 2>&1; then
    LS_COMMAND="gls"
  else
    LS_COMMAND="ls"
  fi
  export HOMEBREW_VERBOSE=1
  export HOMEBREW_CURL_VERBOSE=1
  export HOMEBREW_NO_EMOJI=1
  if hash gdircolors >/dev/null 2>&1; then
    alias dircolors="gdircolors"
    dircolors_enable=1
  fi
  if hash gls >/dev/null 2>&1; then
    alias ls='gls $LS_OPTIONS'
  fi
else
  LS_COMMAND="ls"
fi

# FreeBSD specific stuff
if [[ "$OS_TYPE" == "FreeBSD" ]]; then 
  if hash gls >/dev/null 2>&1; then
  alias ls='gls -al -F'
  LS_COMMAND=gls
  fi
  CLICOLOR=1; export CLICOLOR
  alias portinstall="sudo make config-recursive install clean clean-depends"
  if hash gdircolors >/dev/null 2>&1; then
    alias dircolors="$(which gdircolors)"
    dircolors_enable=1
  fi
fi

# Linux specific stuff
if [[ "$OS_TYPE" == "Linux" ]]; then
  LS_COMMAND=ls
  dircolors_enable=1
fi

# enable ls colorization: 
if [ "$TERM" != "dumb" ]; then
  if [[ "$dircolors_enable" == 1 ]]; then
    eval "$(dircolors "$ZSH"/dircolors)"
    alias ls="$LS_COMMAND $LS_OPTIONS"
  fi
fi

# set $SHELL (dirty hack, sorry for this)
export SHELL="$(which zsh)"

# keychain stuff
if [[ "$OS_TYPE" == "Linux" ]]; then
  ssh_cmd="$(which ssh)"
  function ssh () {
    echo "$@" >> $HOME/.keychain-args
    echo "$(date)" > $HOME/.keychain-output
    # using keychain for gpg made problems, so we only use the id_rsa SSH key here:
    # keychain id_rsa 44248BA0
    keychain --eval --timeout 525600 --noask --nocolor --attempts 5 id_rsa >> $HOME/.keychain-output 2>&1
    [ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`
    [ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh
    [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && . $HOME/.keychain/$HOSTNAME-sh-gpg
    "$ssh_cmd" "$@"
  }
fi

# grep with color
alias grep='grep --color=auto'

# enable ls colorization: 
if [ "$TERM" != "dumb" ]; then
  alias ls="$LS_COMMAND $LS_OPTIONS"
fi

# Fix for KDE Konsole
if [[ ! "$KONSOLE_PROFILE_NAME" == "" ]]; then
  export TERM=xterm-256color
fi

# do not autocorrect sudo commands (fixes "zsh: correct 'vim' to '.vim' [nyae]?")
alias sudo='nocorrect sudo'

# the more brutal attempt, disabling all corrections (whatever that means...)
unsetopt correct{,all} 

# colored grep / less
alias less='less -R'

if type colordiff >/dev/null 2>&1; then
  alias diff='colordiff'
fi

# sudo shell with "s" alias
alias s="sudo -s -E"

# don't require "rehash" after installing a package (seems to NOT work reliably)
setopt nohashdirs

# easy compile function
function compile () {
  echo "[compile zsh function] $@"
  for file in "$@"; do gcc -o "${file%.}" "$file"; done
}

# load mine setup / word selection style
autoload -U colors zsh-mime-setup select-word-style

# enable some colorizations
colors

# minetype setup 
zsh-mime-setup

# use bash word selection style
select-word-style bash



