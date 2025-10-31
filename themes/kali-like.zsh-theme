#!/bin/zsh

#############################################################################
#                                                                           #
#                    KALI-LIKE THEME for Oh-My-Zsh                          #
#                                                                           #
#############################################################################
#                                                                           #
#  For better "kali-like" experience, use FiraCode font for your terminal   #
#  and install zsh-syntax-highlighting and zsh-autosuggestions packages     #
#                                                                           #
#############################################################################
#                                                                           #
# CREDITS :                                                                 #
# Some parts of this code was directly ripped from Kali Linux .zshrc        #
#                                                                           #
#############################################################################
# (C) 2023 Cyril LAMY under the MIT License                                 #
#############################################################################

#####   OPTIONS     #####

USE_SYNTAX_HIGHLIGHTING=no
AUTO_DOWNLOAD_SYNTAX_HIGHLIGHTING_PLUGIN=yes

USE_ZSH_AUTOSUGGESTIONS=no
AUTO_DOWNLOAD_ZSH_AUTOSUGGESTIONS_PLUGIN=yes

PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes

#### END OF OPTIONS #####

setopt autocd              # change directory just by typing its name
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt share_history       # all sessions share the same history files

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

setopt hist_verify            # show command with history expansion to user before running it

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

configure_prompt() {
    ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[067]%}["
    ZSH_THEME_GIT_PROMPT_SUFFIX="] %{$reset_color%}"


    if [[ $UID == 0 || $EUID == 0 ]]; then
        FGPROMPT="$FG[196]"
        CYANPROMPT="$FG[027]"
    else
        CYANPROMPT="$FG[073]"
        FGPROMPT="$FG[027]"
    fi
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'$CYANPROMPT┌$(if [[ -n $VIRTUAL_ENV ]]; then echo "─(%F{white}$(basename $VIRTUAL_ENV)$CYANPROMPT)"; fi)\(%B$FGPROMPT%n@%m%b$CYANPROMPT)-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b$CYANPROMPT]$(git_prompt_info)\n$CYANPROMPT└─%B%(#.%F{red}#.$FGPROMPT$)%b%F{reset} '
            RPROMPT=
            ;;
        oneline)
            PROMPT=$'%B$FGPROMPT%n@%m%b%F{reset}:%B$CYANPROMPT%~%b$(git_prompt_info)%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
}

configure_prompt

if [ "$USE_SYNTAX_HIGHLIGHTING" = yes ]; then

    syntax_highlighting=no

    # enable syntax-highlighting if avalaible

    if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        syntax_highlighting=yes
    fi

    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        syntax_highlighting=yes
    fi

    if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        syntax_highlighting=yes

    fi

    if [ "$syntax_highlighting" = no ]; then
        if [ "$AUTO_DOWNLOAD_SYNTAX_HIGHLIGHTING_PLUGIN" = yes ]; then
            if whence -cp git &> /dev/null; then
                mkdir ~/.zsh >/dev/null 2>&1
                git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting >/dev/null 2>&1
                if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
                    . ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
                    syntax_highlighting=yes
                else
                    echo "git not found, plugin zsh_syntax_highlighting not installed"
                fi
            fi
        fi
    fi


    if [ "$syntax_highlighting" = yes ]; then
    CL_CYAN="073"
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white,underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=$CL_CYAN,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=$CL_CYAN,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=$CL_CYAN,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=$CL_CYAN,underline
        ZSH_HIGHLIGHT_STYLES[path]=fg=white,bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=$CL_CYAN
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=$CL_CYAN
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=$CL_CYAN,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi

    unset syntax_highlighting

fi

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt



# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    alias pacman='pacman --color=auto'


    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

if [ "$USE_ZSH_AUTOSUGGESTIONS" = yes ]; then

    zsh_autosuggestions=no

    # enable auto-suggestions based on completion and  history
    if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        . ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
        # change suggestion color
        ZSH_AUTOSUGGEST_STRATEGY=(completion history)
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
        zsh_autosuggestions=yes
    fi

    if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        # change suggestion color
        ZSH_AUTOSUGGEST_STRATEGY=(completion history)
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
        zsh_autosuggestions=yes
    fi

    if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
        # change suggestion color
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
        ZSH_AUTOSUGGEST_STRATEGY=(completion history)
        zsh_autosuggestions=yes
    fi

    if [ "$zsh_autosuggestions" = no ]; then
        if [ "$AUTO_DOWNLOAD_ZSH_AUTOSUGGESTIONS_PLUGIN" = yes ]; then
            if whence -cp git &> /dev/null; then
                mkdir ~/.zsh >/dev/null 2>&1
                git clone --quiet https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions >/dev/null 2>&1
                if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
                    . ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
                    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
                    ZSH_AUTOSUGGEST_STRATEGY=(completion)
                    zsh_autosuggestions=yes
                fi
            else
                echo "git not found, plugin zsh_autosuggestions not installed"
            fi
        fi
    fi
fi


# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# hide default virtual environment
export VIRTUAL_ENV_DISABLE_PROMPT=1
export CONDA_CHANGEPS1=false