# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/sek/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bullet-train"

if [[ $ZSH_THEME = "bullet-train" ]]; then
    BULLETTRAIN_PROMPT_ORDER=(
        time
        status
        custom
        context
        dir
        screen
        perl
        ruby
        go
        git
        hg
        cmd_exec_time
    )
    BULLETTRAIN_DIR_EXTENDED=2
    BULLETTRAIN_CONTEXT_DEFAULT_USER="sek"

    CUSTOM_GIT_SHORT_BRANCH="short"
    CUSTOM_GIT_SHORT_BRANCH_LENGTH=90
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export http_proxy="http://proxy.open.ch:8080"
export https_proxy="http://proxy.open.ch:8080"
export no_proxy=.open.ch

export PATH=~/.scripts:$PATH

source ~/perl5/perlbrew/etc/bashrc

function upload_pkg_files_to_host {
    HOST="$1"    
    TMP=`ssh lamarr "mktemp -d -p /shared/tmp rsync.sek.XXXXXXXX"`
  
    for FILE in "${@:2}"; do
        NEW_PATH=`grealpath $FILE | sed -e 's!.*pkg-osag!/opt/OSAG!'`               # path replacement from local path to host path

        NEW_PATH=`echo "$NEW_PATH" | sed -e 's!\(OSAGnurs3/\)addon!\1etc!'`         # path replacement for OSAGnurs3 addon files
        NEW_PATH=`echo "$NEW_PATH" | sed -e 's!\(OSAGnurs3/\)nurse/lib!\1perl!'`    # path replacement for OSAGnurs3 lib files

        NEW_PATH=`echo "$NEW_PATH" | sed -e 's!\(OSAGrad/\)addon!\1!'`              # path replacement for OSAGrad addon files
        rsync -avz --quiet $FILE lamarr:$TMP

        ssh lamarr "rsync -rlt --checksum -vz --no-perms --no-owner --no-group --quiet $TMP/$(basename $FILE) $HOST:$NEW_PATH"
    done
    ssh lamarr "rm -rf $TMP"
}

function copy_to_host {
    TMP=`ssh lamarr "mktemp -d -p /shared/tmp rsync.sek.XXXXXXXX"`
    rsync -avz --quiet $1 lamarr:$TMP;
    ssh lamarr "rsync -rlt --checksum -vz --no-perms --no-owner --no-group --quiet $TMP/ $2";
    ssh lamarr "rm -rf $TMP";
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

