#!/bin/zsh
ZSH_THEME_GIT_PROMPT_CLEAN="$fg_bold[grey]Clean!"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg_bold[red]Dirty!"

precmd(){
    local Q_ERRNO=$?;
    local Q_FRAME_BGN=$fg_bold[yellow]'['$reset_color;
    local Q_FRAME_MID=$fg_bold[yellow]':'$reset_color;
    local Q_FRAME_END=$fg_bold[yellow]']'$reset_color;
    local PWD0=$PWD'/'
    [[ $PWD0 =~ $HOME'/' ]] && PWD0="${PWD[@]//$HOME/~}"/
    Q_PROMPT='';
    Q_PROMPT=${Q_PROMPT}${Q_FRAME_BGN};
    Q_PROMPT=${Q_PROMPT}$fg_bold[green]$HOST;
    Q_PROMPT=${Q_PROMPT}${Q_FRAME_MID};
    Q_PROMPT=${Q_PROMPT}$fg_bold[green]$USER;
    Q_PROMPT=${Q_PROMPT}${Q_FRAME_MID};
    Q_PROMPT=${Q_PROMPT}' '$fg_bold[blue]$PWD0' ';
    Q_PROMPT=${Q_PROMPT}$fg_bold[cyan]$(__git_ps1 "$fg_bold[yellow]GIT:($fg_bold[cyan]%s $(parse_git_dirty)$fg_bold[yellow]) ");
    Q_PROMPT=${Q_PROMPT}${Q_FRAME_END}' ';
    Q_PROMPT=${Q_PROMPT}${Q_ERRNO_STR};
    echo $Q_PROMPT;
    PROMPT="%(?:%{$fg_bold[grey]%}:%{$fg_bold[red]%})"$(printf "[0x%02X|%03d]" $Q_ERRNO $Q_ERRNO)"%{$fg_bold[cyan]%}➜ %{$reset_color%}";
    RPROMPT="%{$fg[green]%}$(date +'%Y/%m/%d %H:%M:%S')%{$reset_color%}";
}

### ALIAS 
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias emacs='emacs -nw'
alias vi='vim'

alias llah='ls -laFh'
alias lla='ls -laF'
alias llh='ls -lhF'
alias ll='ls -lF'
alias l='ls -CF'
