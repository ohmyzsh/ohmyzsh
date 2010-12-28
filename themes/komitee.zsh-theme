if [ -f ~/.pathrc ]; then
    path=()
    typeset -U path
    for dir in $(<$HOME/.pathrc); do 
        path+=($dir)
    done 
fi 

if [ -f ~/.manpathrc ]; then
    typeset -U manpath
    manpath=()
    for dir in $(<$HOME/.manpathrc); do
        manpath+=($dir)
    done 
fi

function current_dir() {
    local -a regex
    local current_dir=$(pwd)
    local full_dir=${current_dir/${HOME}/\~}
    if [[ ${#full_dir} > 15 ]]; then
        if [[ ${full_dir} =~ "^(~/|/)([^/]+)/.+/([^/]+)$" ]]; then
            local short_dir="$match[1]$match[2]/.../$match[3]"
            if [[ ${#full_dir} > ${#short_dir} ]]; then
                echo $short_dir
            else
                echo $full_dir
            fi
        else
            echo $full_dir
        fi
    else
        echo $full_dir
    fi
}

function svn_repository() {
    if [ -d .svn ]; then
        local -a regex
        svn_info=$(svn info)
        if [[ ${svn_info} =~ "Repository Root: \S+/(\S+)" ]]; then
            echo "%{$fg[blue]%}(svn:$match)%{$reset_color%}"
        fi
    fi
}

# setup basic prompt
local user="$(whoami)"

if [ "$user" = "root" ]; then 
    local user_host="%{$fg[yellow]%}_ROOT_%{$reset_color%}@%{$fg[red]%}$(~/scripts/shorthost)%{$reset_color%}"
    local prompt_color=red
elif [ "$user" = "komitee" ] || [ "$user" = "mkomitee" ]; then
    local user_host="%{$fg[red]%}%{$fg[yellow]%}@%{$fg[magenta]%}$(~/scripts/shorthost)%{$reset_color%}"
    local prompt_color=white
else 
    local user_host="%{$fg[yellow]%}%n%{$fg[blue]%}@%{$fg[magenta]%}$(~/scripts/shorthost)%{$reset_color%}"
    local prompt_color=yellow
fi

local prompt_char="%{$fg[$prompt_color]%}%#%{$reset_color%}"

jobs_prompt_info() {
    local JOBS_S_C=$(jobs -s | wc -l | sed -e 's/ //g')
    local JOBS_R_C=$(jobs -r | wc -l | sed -e 's/ //g')
    if [ "$JOBS_S_C" = "0" ] || [ "$JOBS_S_C" = "" ]; then
        local JOBS_S=""
    else
        local JOBS_S="%{$fg[red]%}[%{$fg[yellow]%}${JOBS_S_C}%{$fg[red]%}]%{$reset_color%}"
    fi

    if [ "$JOBS_R_C" = "0" ] || [ "$JOBS_R_C" = "" ]; then
        local JOBS_R=""
    else
        local JOBS_R="%{$fg[green]%}[%{$fg[yellow]%}${JOBS_R_C}%{$fg[green]%}]%{$reset_color%}"
    fi

    echo "${JOBS_S}${JOBS_R}"
}

if [ "$SHLVL" = "0" ] || [ "$SHLVL" = "1" ] || [ "$SHLVL" = "" ]; then
    local shell_level=""
else
    local shell_level="%{$fg[cyan]%}(%{$fg[red]%}$[${SHLVL} - 1]%{$fg[cyan]%})%{$reset_color%}"
fi

# setup command result indicator
local exit_code="%(?,,%{$fg[red]%}[%?]%{$reset_color%})"

# Put it all together
PROMPT='${exit_code}%{$fg[cyan]%}[${user_host} %{$fg[yellow]%}$(current_dir)%{$fg[cyan]%}]$(jobs_prompt_info)${shell_level}${prompt_char} '


# Setup vi mode indicator
MODE_INDICATOR="%{$fg_bold[yellow]%}<CMD>%{$reset_color%}"

# Setup git prompt info
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}(git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# setup right prompt
RPROMPT='$(svn_repository)$(git_prompt_info)$(vi_mode_prompt_info)'

if [ "$DISABLE_LS_COLORS" != "true" ]
then
  # Find the option for using colors in ls, depending on the version: Linux or BSD
  ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty -F -h' || alias ls='ls -GFh'
fi
# vim: set ft=zsh ts=4 sw=4 et:
