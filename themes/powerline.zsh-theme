PROMPT='${SMILEY}$BG[024]$FG[255] %n %{$reset_color%}$FG[024]$BG[102]⮀$FG[255]%m %{$reset_color%}$BG[255]$FG[102]⮀%{$reset_color%}$FG[000]$BG[255] $(prompt_char)%{$reset_color%}$FG[255]⮀%{$reset_color%}'
RPROMPT='in %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}'

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}


ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"


SMILEY="%(?,$BG[154]$FG[192] ✔ $BG[024]$FG[154]⮀,$BG[131]$FG[255] ✘ $BG[024]$FG[131]⮀)"