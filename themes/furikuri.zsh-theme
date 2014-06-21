function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

PROMPT='%{$fg[yellow]%}λ %m %{$fg[green]%}$(collapse_pwd) $(git_prompt_info)%{$reset_color%}
$fg[yellow]%}→%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}→ λ %{$fg[blue]%}git %{$fg[cyan]%}⭠ "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"

# See http://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxbxbxbxbxbxbx"
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=31;40:cd=31;40:su=31;40:sg=31;40:tw=31;40:ow=31;40:"