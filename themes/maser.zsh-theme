# theme based on alanpeabody and my old Bash prompt

# PWD, truncated to 20 characters if it is too long
function collapse_pwd {
    local pwd_truncation_length=20
    local dir=$(pwd)

    if $(echo $dir | grep "^$HOME" >>/dev/null)
    then
        dir="~$(echo $dir | awk -F$HOME '{print $2}')"
    fi

    if [ $(echo -n $dir | wc -c | tr -d " ") -gt $pwd_truncation_length ]
    then
        dir="…${dir[-$pwd_truncation_length,-1]}"
    fi
    echo -n $dir
}

# compares HEAD to its remote and prints strings like ahead(2), behind(1) and diverged(1 2)
function git_remote_information {

    local git_status="$(git status 2>/dev/null)"

    if [ -n "$git_status" ] ; then
        local remote_information

        if grep -q "ahead of" <<< $git_status ; then
            local n_commits="$(egrep -o "by [0-9]+ commit" <<< $git_status | awk '{ print $2 }')"
            remote_information=" ahead($n_commits)"
        fi

        if grep -q "have diverged" <<< $git_status ; then
            local n_commits="$(egrep -o "have [0-9]+ and [0-9]+ different commit" <<< $git_status | awk '{ print $2,$4 }')"
            remote_information=" diverged($n_commits)"
        fi

        if grep -q "Your branch is behind" <<< $git_status ; then
            local n_commits="$(egrep -o "by [0-9]+ commit" <<< $git_status | awk '{ print $2 }')"
            remote_information=" behind($n_commits)"
        fi
    fi
    echo $remote_information
}

local pwd='%{$fg[white]%}$(collapse_pwd)%{$reset_color%}'

local return_code='%(?..%{$fg[red]%}%? ↵%{$reset_color%})'
local git_information='$(git_prompt_status) %{$reset_color%}$(git_prompt_info)%{$reset_color%}%{$fg[cyan]%}$(git_remote_information)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}A"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[green]%}R"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}═"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}M"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}D" # this is the opposite of untracked
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}??"

PROMPT="${pwd}» "
RPROMPT="${return_code} ${git_information}"
