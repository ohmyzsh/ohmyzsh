# from http://blog.munge.net/2011/10/fun-with-zsh-themes/
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# TODO: Currently not used because it renders the prompt unusably slow in large
# hg directories. Could not find a way to disable it only for mercurial though.
function vcprompt_info {
    vcprompt --format-git "on ± %{$fg[magenta]%}%b%{$reset_color%}%{$fg[green]%}%u%m%a%{$reset_color%}" \
             --format    "on %s %{$fg[magenta]%}%b%{$reset_color%}%{$fg[green]%}%u%m%{$reset_color%}"
             --format-hg  "on ☿ %{$fg[magenta]%}%b%{$reset_color%}%{$fg[green]%}%u%m%{$reset_color%}" \
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

setopt PROMPTBANG
PROMPT='%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}$(box_name)%{$reset_color%} in %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}
$(virtualenv_info)${fg_bold[white]}[!!!%(?,,%{%}:%?)]%{$reset_color%} %# '

local return_status="%{$fg[red]%}%(?..✘)%{$reset_color%}"
RPROMPT='${return_status}%{$reset_color%}'
