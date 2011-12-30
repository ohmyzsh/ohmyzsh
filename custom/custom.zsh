# Set less options
if [[ -x $(which less) ]]
then
    export PAGER="less"
    export LESS="--ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm --RAW-CONTROL-CHARS --quit-if-one-screen --no-init"
    if [[ -x $(which lesspipe.sh) ]]
    then
	LESSOPEN="| lesspipe.sh %s"
	export LESSOPEN
    fi
fi

# Set default editor
if [[ -x $(which vim) ]]
then
    export EDITOR="vim"
    export USE_EDITOR=$EDITOR
    export VISUAL=$EDITOR
fi


# Zsh settings for history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd.."
export HISTSIZE=25000
export HISTFILE=~/.zsh_history
export SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Say how long a command took, if it took more than 30 seconds
export REPORTTIME=30

# Zsh spelling correction options
#setopt CORRECT
#setopt DVORAK

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE

# Don’t write over existing files with >, use >! instead
setopt NOCLOBBER

# Don’t nice background processes
setopt NO_BG_NICE

# Watch other user login/out
watch=notme
export LOGCHECK=60

# Enable color support of ls
if [[ "$TERM" != "dumb" ]]; then
    if [[ -x `which dircolors` ]]; then
	eval `dircolors -b`
	alias 'ls=ls --color=auto'
    fi
fi

# Short command aliases
alias 'grep=grep --colour'


# Play safe!
alias 'rm=rm -i'
alias 'mv=mv -i'
alias 'cp=cp -i'

# For convenience
alias 'mkdir=mkdir -p'
alias 'dus=du -ms * | sort -n'

# Typing errors...
alias 'cd..=cd ..'


# Quick find
f() {
    echo "find . -iname \"*$1*\""
    find . -iname "*$1*"
}


# some more ls aliases
alias ls="ls --color"
alias ll='ls -lh --color'
alias lla='ls -lah --color'
alias la='ls -Ah --color'
alias l='ls -CF --color'

#export TERM="screen-256color"
export TERM=rxvt


alias browse="vimprobable2"
alias jump="ssh root@195.42.120.16 -p54654 -i /home/epegzz/.ssh/id_rsa.intranet.local"
alias technobase="mplayer http://listen.technobase.fm/tunein-dsl-pls"
alias housetime="mplayer http://listen.housetime.fm/tunein-dsl-pls"
alias servdir="python -m SimpleHTTPServer"
alias lsnew=" ls -al --time-style=+%D | grep `date +%D` "
alias whatip='wget -q -O - http://www.whatismyip.org && echo'
alias tmux="tmux -u"

PATH="~/bin:/usr/local/bin:${PATH}"


PATH="~/bin:/usr/local/bin:${PATH}:/opt/flex-sdk/bin:/usr/lib/jvm/java-6-openjdk/bin:/usr/share/java/apache-ant/bin"
JAVA_HOME="/usr/lib/jvm/java-6-openjdk"

export RED5_HOME="/opt/red5"


# needed for vcn/flashViewer and vcn/flashSender
export LIBFLASHCLIENT_DIR=/home/epegzz/Projects/vcn/libFlashClient/dist


# alias for t
alias t='python2.7 ~/Projects/t/t.py --task-dir ~/tasks --list tasks'
alias b='python2.7 ~/Projects/t/t.py --task-dir . --list bugs'

# make vim 256 colors work in tmux
alias tmux='TERM=xterm-256color tmux'

source /usr/local/bin/f.sh
alias v='f -e vim' # quick opening files with vim
alias m='f -e mplayer' # quick opening files with mplayer
alias j='d -e cd' # quick cd into directories, mimicking autojump and z





# virtualenv stuff
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

