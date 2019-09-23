# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="stibbons"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Virtualenvwrapper plugin - Disable directory name discovery
DISABLE_VENV_CD="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
    autopep8
    brew
    colored-man-pages
    command-not-found
    common-aliases
    cp
    dircycle
    django
    docker
    encode64
    extract
    git-extras
    git-remote-branch
    git2
    grin
    helm
    iterm2
    jira
    jump
    kubectl
    launch_trial
    launchctl
    lol
    minikube
    npm
    osx
    pep8
    pip
    pyenv
    pylint
    python
    repo
    rsync
    sublime
    subliminal
    tig
    ufw
    vim-scp
    work-aliases
    yarn
    zsh-iterm-touchbar
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
# User configuration
if [ -e $HOME/bin ]; then export PATH="$HOME/bin:$PATH"; fi
if [ -e /usr/local/bin ]; then export PATH="/usr/local/bin:$PATH"; fi
if [ -e /usr/local/opt/gettext/bin ]; then export PATH="/usr/local/opt/gettext/bin:$PATH"; fi

zstyle ':completion:*:descriptions' format '%B%d%b'
# Language configuration
if [ -z "$LC_ALL" ]; then export LC_ALL=en_US.UTF-8; fi
if [ -z "$LANG" ]; then export LANG=en_US.UTF-8; fi

source $ZSH/oh-my-zsh.sh

# Enviroment variables overwrite
export EDITOR='vim'
export LESS='-RX'

unsetopt correctall

if [ -e ~/.profile ]; then source ~/.profile; fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

[ -d "/Users/az02065/Library/Python/3.7/bin" ] && export PATH=/Users/az02065/Library/Python/3.7/bin:$PATH

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

[ -f $HOME/.pyenv/shims/python ] && export PIPENV_PYTHON=$HOME/.pyenv/shims/python
[ -d $HOME/.local/bin ] && export PATH=$HOME/.local/bin:$PATH
[ -d $HOME/bin ] && export PATH=$HOME/bin:$PATH
[ -f $HOME/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh
