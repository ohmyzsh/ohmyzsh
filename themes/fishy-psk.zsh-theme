# ZSH Theme emulating the Fish shell's default prompt.

_fishy_collapsed_wd() {
    echo $(pwd | perl -pe '
   BEGIN {
      binmode STDIN,  ":encoding(UTF-8)";
      binmode STDOUT, ":encoding(UTF-8)";
   }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
')
}

local user_color='blue'
[ $UID -eq 0 ] && user_color='red'
PROMPT='%{$fg[$user_color]%}$(_fishy_collapsed_wd)%{$reset_color%}%(!.#.>) '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

local return_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
# RPROMPT="${RPROMPT}"'${return_status}'
RPROMPT="${RPROMPT}"'${return_status}$(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[white]%}＋"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[white]%}≠"
ZSH_THEME_GIT_PROMPT_DELETED="💀"
ZSH_THEME_GIT_PROMPT_RENAMED="❞"
ZSH_THEME_GIT_PROMPT_UNMERGED="❕"
ZSH_THEME_GIT_PROMPT_UNTRACKED="🆕"
