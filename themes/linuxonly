# vim: set ts=2 textwidth=0

autoload -U add-zsh-hook
autoload -Uz vcs_info
local c0=$(printf "\033[0m")
local c1=$(printf "\033[38;5;215m")
local c2=$(printf "\033[38;5;209m")
local c3=$(printf "\033[38;5;203m")
local c4=$(printf "\033[33;4m")
local c5=$(printf "\033[38;5;137m")
local c6=$(printf "\033[38;5;240m")
local c7=$(printf "\033[38;5;149m")
local c8=$(printf "\033[38;5;126m")
local c9=$(printf "\033[38;5;162m")

local foopath=$(perl /home/scp1/bin/foopath)

if [ "$TERM" = "linux" ]; then
    c1=$(printf "\033[34;1m")
    c2=$(printf "\033[35m")
    c3=$(printf "\033[31m")
    c4=$(printf "\033[31;1m")
    c5=$(printf "\033[32m")
    c6=$(printf "\033[32;1m")
    c7=$(printf "\033[33m")
    c8=$(printf "\033[33;1m")
    c9=$(printf "\033[34m")
fi

#local newtv=$(perl $HOME/devel/newtv.pl)
local newtv=''

zstyle ':vcs_info:*' actionformats \
    '%{$c8%}(%f%s)%{$c7%}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
    "%{$c8%}%s%{$c7%}:%{$c7%}(%{$c9%}%b%{$c7%})%f "
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git

add-zsh-hook precmd prompt_jnrowe_precmd

prompt_jnrowe_precmd () {
    vcs_info

    if [ "${vcs_info_msg_0_}" = "" ]; then
        #dir_status="|%F{3}%n%F{7}@%F{3}%m%F{7}:%F{9}%l%f"
        #dir_status="$c1%n%F{7}@%F{9}%m%F{7}:%F{12}%/"
        dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$c4%}%/ %{$c0%}(%{$c5%}%?%{$c0%})"
        #dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$foopath%} %{$c0%}(%{$c5%}%?%{$c0%})"
        
        PROMPT='%{$fg_bold[green]%}%p%{$reset_color%}${vcs_info_msg_0_}${dir_status} ${ret_status}%{$reset_color%}
> '
    elif [[ $(git diff --cached --name-status 2>/dev/null ) != "" ]]; then
        dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$c4%}%/ %{$c0%}(%{$c5%}%?%{$c0%})"
        PROMPT='${vcs_info_msg_0_}
%{$fg_bold[green]%}%p%{$reset_color%}${dir_status} ${vcs_info_msg_0_}%{$reset_color%}
> '
    
    elif [[ $(git diff --name-status 2>/dev/null ) != "" ]]; then
        dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$c4%}%/ %{$c0%}(%{$c5%}%?%{$c0%})"

        PROMPT='${vcs_info_msg_0_}
%{$fg_bold[green]%}%p%{$reset_color%}${dir_status}%{$reset_color%}
%{$c9%}·>%{$c0%} '
    else
        dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$c4%}%/ %{$c0%}(%{$c5%}%?%{$c0%})"
        PROMPT='${vcs_info_msg_0_}
%{$fg_bold[green]%}%p%{$reset_color%}${dir_status} ${vcs_info_msg_0_}%{$reset_color%}
> '
        
    fi
}


#PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$reset_color%} ${vcs_info_msg_0_}${dir_status}%{$reset_color%}
#> '

# vim: set ft=zsh ts=4 sw=4 et:


