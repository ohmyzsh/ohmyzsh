# if [[ -n $SSH_CONNECTION ]]; then
# 	export PS1='%m:%3~$(git_info_for_prompt)%# '
# else
# 	export PS1='%3~$(git_info_for_prompt)%# '
# fi

if (( ${+commands[mate]} ));then
	export EDITOR='mate'
elif (( ${+commands[mvim]} ));then
	export EDITOR="mvim"
else
	export EDITOR='vim'
fi

# uncommented since this is system dependent
# export PATH="$HOME/bin:$HOME/.bin:/usr/local/homebrew/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/git/bin:$PATH"
# export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
#
# uncommented since this is system dependent (caused error on configure nginx on my server)
# export CC=gcc-4.2

# LANG is required by some programs, like ruby, so ensure that it is set (to UTF)
export LANG=en_US.UTF-8

if [[ -e /usr/libexec/java_home ]]; then
  export JAVA_HOME="`/usr/libexec/java_home`"
fi

export IDEA_JDK="$JAVA_HOME"
fpath=(~/.zsh/functions $fpath)

autoload -U ~/.zsh/functions/*(:t)

#HISTFILE=~/.zsh_history
#HISTSIZE=1000
#SAVEHIST=1000
#REPORTTIME=10 # print elapsed time when more than 10 seconds

#setopt NO_BG_NICE # don't nice background tasks
#setopt NO_HUP
#setopt NO_LIST_BEEP
#setopt LOCAL_OPTIONS # allow functions to have local options
#setopt LOCAL_TRAPS # allow functions to have local traps
#setopt HIST_VERIFY
## setopt SHARE_HISTORY # share history between sessions ???
unsetopt EXTENDED_HISTORY # add timestamps to history
#setopt PROMPT_SUBST
#setopt CORRECT
#setopt COMPLETE_IN_WORD
#setopt IGNORE_EOF
#setopt AUTOCD # change to directory without "cd"

#setopt APPEND_HISTORY # adds history
#setopt INC_APPEND_HISTORY # SHARE_HISTORY  # adds history incrementally and share it across sessions
#setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
#setopt HIST_REDUCE_BLANKS

#zle -N newtab

#bindkey '^[^[[D' backward-word
#bindkey '^[^[[C' forward-word
#bindkey '^[[5D' beginning-of-line
#bindkey '^[[5C' end-of-line
#bindkey '^[[3~' delete-char
#bindkey '^[^N' newtab
#bindkey '^?' backward-delete-char 
#bindkey '\e[3~' delete-char

# reverse everything above and set it to default vim key-binding
#bindkey -e
## bindkey '' history-incremental-search-backward
#bindkey '' backward-word
#bindkey '' forward-word

# ctrl-< and crtrl-> still works
export DISABLE_AUTO_UPDATE=true

# rvm, should be at the end of this config file
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

