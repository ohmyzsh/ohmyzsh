function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

RPROMPT='%(?.%{$fg[green]%}✔ .%{$fg[red]%}✖ )% %{$reset_color%}'

PROMPT='%{$fg[yellow]%}λ %m %{$fg[green]%}$(collapse_pwd) $(git_prompt_info)%{$reset_color%}$(git_prompt_status)%{$reset_color%}
$fg[yellow]%}→%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}→ λ %{$fg[blue]%}git %{$fg[cyan]%}⭠ "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ☂" # Ⓓ
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭" # ⓣ
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ☀" # Ⓞ

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✚" # ⓐ ⑃
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ⚡"  # ⓜ ⑁
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖" # ⓧ ⑂
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➜" # ⓡ ⑄
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ♒" # ⓤ ⑊
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%} 𝝙"

# See http://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxbxbxbxbxbxbx"
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=31;40:cd=31;40:su=31;40:sg=31;40:tw=31;40:ow=31;40:"