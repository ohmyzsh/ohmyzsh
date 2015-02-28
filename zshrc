# ezzsh - zshrc

# path to your zsh configuration.
ZSH="$HOME/.zsh"

# export ZSH_THEME="random"
# export ZSH_THEME="ezzsh" # name of zsh theme
# export ZSH_THEME="powerline" # name of zsh theme
export ZSH_THEME="powerline-with-hostname" # name of zsh theme

# Set this to true to use case-sensitive completion
CASE_SENSITIVE="false" # bool

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true" # bool

# Uncomment following line if you want to disable colors in ls
DISABLE_LS_COLORS="false" # bool

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="false" # bool

# Uncomment following line if you want disable red dots displayed while waiting for completion
DISABLE_COMPLETION_WAITING_DOTS="true" # bool

# plugins to load (array)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)


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

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH

# set $EDITOR
export EDITOR='vim'

# man pages: color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;33m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# zsh fix for ssh host completion from ~/.ssh/config
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}

# needed to keep backgrounded jobs running when exiting zsh:
setopt NO_HUP

# homebrew
# githup api token, in the format, example: 
# > export HOMEBREW_GITHUB_API_TOKEN=XXXXX
if [[ -e ~/.homebrew-github-api-token ]]; then
  source ~/.homebrew-github-api-token
fi

# mosh setup
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

# set ls options
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

if [[ "$OS_TYPE" == "FreeBSD" ]]; then 
  alias ls='ls -al -F'
  CLICOLOR=1; export CLICOLOR
  alias portinstall="sudo make config-recursive install clean clean-depends"
  if hash gdircolors >/dev/null 2>&1; then
    alias dircolors="$(which gdircolors)"
    dircolors_enable=1
  fi
fi

# enable ls colorization: 
if [ "$TERM" != "dumb" ]; then
  if [[ "$dircolors_enable" == 1 ]]; then
    eval "$(dircolors "$ZSH"/dircolors)"
    alias ls="$LS_COMMAND $LS_OPTIONS"
  fi
fi

# set $SHELL:
export SHELL="$(which zsh)"

# keychain stuff
if [[ "$OS_TYPE" == "Linux" ]]; then
  ssh_cmd="$(which ssh)"
  function ssh () {
    echo "$@" >> $HOME/.keychain-args
    echo "$(date)" > $HOME/.keychain-output
    # using keychain for gpg made problems, so we only use the id_rsa SSH key here:
    # keychain id_rsa 44248BA0
    keychain id_rsa >> $HOME/.keychain-output 2>&1
    [ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`
    [ -f $HOME/.keychain/$HOSTNAME-sh ] && \
      . $HOME/.keychain/$HOSTNAME-sh
    [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
      . $HOME/.keychain/$HOSTNAME-sh-gpg
    "$ssh_cmd" "$@"
  }
fi

# grep with color
alias grep='grep --color=auto'

# enable ls colorization: 
if [ "$TERM" != "dumb" ]; then
  if [[ "$dircolors_enable" == 1 ]]; then
    eval "$(dircolors "$ZSH"/dircolors)"
    alias ls="$LS_COMMAND $LS_OPTIONS"
  fi
fi

# do not autocorrect sudo commands (fixes "zsh: correct 'vim' to '.vim' [nyae]?")
alias sudo='nocorrect sudo'

# the more brutal attempt:
unsetopt correct{,all} 

# colored grep / less
alias grep="grep --color='always'"
alias less='less -R'
alias diff='colordiff'



