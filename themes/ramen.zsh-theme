# Ramen theme - Based on Dark Blood and the old-school zsh elite prompts

function virtualenv_prompt_info {
    if [ $VIRTUAL_ENV ]; then
        echo "$ZSH_THEME_VIRTUALENV_PROMPT_PREFIX$(basename $VIRTUAL_ENV)$ZSH_THEME_VIRTUALENV_PROMPT_SUFFIX"
    fi
}

PROMPT=$'%{$fg_bold[black]%}┌%{$reset_color%}%{$fg[cyan]%}[%{$fg_bold[white]%}%n%{$reset_color%}%{$fg_bold[black]%}@%{$fg_bold[white]%}%m%{$reset_color%}%{$fg[cyan]%}]%{$fg_bold[black]%}-%{$reset_color%}%{$fg[cyan]%}[%{$fg_bold[white]%}%!%{$fg_bold[black]%}/%{$fg_bold[white]%}%y%{$reset_color%}%{$fg[cyan]%}]%{$fg_bold[black]%}-%{$reset_color%}%{$fg[cyan]%}[%{$fg_bold[white]%}%D{%I:%M%P}%{$fg_bold[black]%}:%{$fg_bold[white]%}%D{%m/%d/%y}%{$reset_color%}%{$fg[cyan]%}]%{$(git_prompt_info)%}%{$(virtualenv_prompt_info)%}
%{$fg_bold[black]%}└%{$reset_color%}%{$fg[cyan]%}[%{$fg_bold[white]%}%#%{$fg_bold[black]%}:%{$fg_bold[white]%}${PWD/#$HOME/~}%{$reset_color%}%{$fg[cyan]%}]%{$fg_bold[black]%}>%{$reset_color%} '
PS2=$' %{$fg[cyan]%}|%{$fg_bold[black]%}>%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[black]%}-%{$reset_color%}%{$fg[cyan]%}[%{$fg_bold[white]%}git%{$fg_bold[black]%}:%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[cyan]%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%}*%{$reset_color%}"

ZSH_THEME_VIRTUALENV_PROMPT_PREFIX="%{$fg_bold[black]%}-%{$reset_color%}%{$fg[cyan]%}[%{$fg_bold[white]%}workon%{$fg_bold[black]%}:%{$fg_bold[white]%}"
ZSH_THEME_VIRTUALENV_PROMPT_SUFFIX="%{$reset_color%}%{$fg[cyan]%}]"
