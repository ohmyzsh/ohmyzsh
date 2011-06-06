if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi


PROMPT="%{$fg[white]%}$?|%n %{$fg[$NCOLOR]%}%m ➤ %{$reset_color%}"
RPROMPT='%~%{$fg[$NCOLOR]%}%p %{$fg[$NCOLOR]%}$(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}(%{$fg[$NCOLOR]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# See http://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxbxbxbxbxbxbx"
export LS_COLORS="di=33;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=31;40:cd=31;40:su=31;40:sg=31;40:tw=31;40:ow=31;40:"

