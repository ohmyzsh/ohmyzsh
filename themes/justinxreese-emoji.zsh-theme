function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

function battery_charge {
    echo `$BAT_CHARGE` 2>/dev/null
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

PROMPT='🙇 %{$fg[magenta]%}%n%{$reset_color%} 📱 %{$fg[yellow]%}%m%{$reset_color%} 📦 %{$fg_bold[blue]%}$(collapse_pwd)%{$reset_color%}$(git_prompt_info)
$(virtualenv_info)$(prompt_char) '

RPROMPT='$(battery_charge)'

ZSH_THEME_GIT_PROMPT_PREFIX=" 🔀 %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
